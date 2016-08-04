# frozen_string_literal: true
require 'rainforest'

class RainforestCli::Deleter
  attr_reader :test_files, :remote_tests

  def initialize(options)
    @file_name = options.file_name
    @test_files = RainforestCli::TestFiles.new(options)
    @remote_tests = RainforestCli::RemoteTests.new(options.token)
  end

  def delete
    validate_file_extension
    delete_remote_test(test_file)
    delete_local_file(test_file.file_name)
  end

  private

  def validate_file_extension
    if !rfml_extension?
      logger.fatal "Error: file extension must be .rfml"
      exit 2
    end
  end

  def rfml_extension?
    extname = File.extname(@file_name)
    RainforestCli::TestFiles::FILE_EXTENSION == extname
  end

  def delete_local_file(path_to_file)
    File.delete(path_to_file)
  end

  def delete_remote_test(rfml_test)
    Rainforest::Test.delete(primary_key_dictionary[rfml_test.rfml_id])
  rescue Exception => e
    logger.fatal "Unable to delete remote rfml test"
    exit 2
  end

  def test_file
    @test_file ||= rfml_tests.detect do |rfml_test|
      rfml_test.file_name == @file_name
    end
  end

  def rfml_tests
    @rfml_tests ||= test_files.test_data
  end

  def primary_key_dictionary
    @primary_key_dictionary ||= remote_tests.primary_key_dictionary
  end

  def logger
    RainforestCli.logger
  end
end
