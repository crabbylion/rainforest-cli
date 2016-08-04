# frozen_string_literal: true
describe RainforestCli::HttpClient do
  subject { described_class.new({ token: 'foo' }) }

  describe '#get' do
    describe 'maximum tolerated exceptions' do
      let(:url) { 'http://some.url.com' }

      before do
        allow(HTTParty).to receive(:get).and_raise(SocketError)
      end

      context 'retries_on_failures omitted' do
        it 'raises the error on the first exception' do
          expect(HTTParty).to receive(:get).once
          expect { subject.get(url) }.to raise_error(Http::Exceptions::HttpException)
        end
      end

      context 'retries_on_failures == false' do
        it 'raises the error on the first exception' do
          expect(HTTParty).to receive(:get).once
          expect { subject.get(url, {}, retries_on_failures: false) }.to raise_error(Http::Exceptions::HttpException)
        end
      end

      context 'retries_on_failures == true' do
        let(:response) { instance_double('HTTParty::Response', code: 200, body: {foo: :bar}.to_json) }
        let(:delay_interval) { described_class::RETRY_INTERVAL }
        subject { described_class.new({ token: 'foo' }).get(url, {}, retries_on_failures: true) }

        it 'it sleeps after failures before a retry' do
          expect(HTTParty).to receive(:get).and_raise(SocketError).once.ordered
          expect(HTTParty).to receive(:get).and_return(response).ordered
          expect(Kernel).to receive(:sleep).with(delay_interval).once
          expect { subject }.to_not raise_error
        end

        it 'sleeps for longer periods with repeated exceptions' do
          expect(HTTParty).to receive(:get).and_raise(SocketError).exactly(3).times.ordered
          expect(HTTParty).to receive(:get).and_return(response).ordered
          expect(Kernel).to receive(:sleep).with(delay_interval).once
          expect(Kernel).to receive(:sleep).with(delay_interval * 2).once
          expect(Kernel).to receive(:sleep).with(delay_interval * 3).once
          expect { subject }.to_not raise_error
        end

        it 'returns the response upon success' do
          expect(HTTParty).to receive(:get).and_raise(SocketError).once.ordered
          expect(HTTParty).to receive(:get).and_return(response).ordered
          expect(Kernel).to receive(:sleep).with(delay_interval).once
          expect(subject).to eq(JSON.parse(response.body))
        end
      end
    end

    describe 'non 200 codes' do
      context '404 not found'do
        let(:url) { 'http://some.url.com' }
        let(:response) { instance_double('HTTParty::Response', code: 404, body: {'error'=>'some error', 'type'=>'some type'}.to_json) }
        subject { described_class.new({ token: 'foo' }).get(url, {}) }

        before do
          allow(HTTParty).to receive(:get).and_raise(SocketError)
        end

        it 'gets an error 404 and prints the error' do
          expect(HTTParty).to receive(:get).and_return(response)
          expect_any_instance_of(Logger).to receive(:warn).with('Status Code: 404, {"error":"some error","type":"some type"}')
          expect(subject)
        end

        it 'returns nil' do
          expect(HTTParty).to receive(:get).and_return(response)
          expect(subject).to eq(nil)
        end
      end
    end
  end
end
