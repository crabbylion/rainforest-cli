package main

import (
	"io"
	"log"
	"os"
)

var apiToken string
var baseURL = "https://app.rainforestqa.com/api/1"
var out io.Writer = os.Stdout

func main() {
	command := os.Args[1]

	switch command {
	case "sites":
		printSites()
	default:
		log.Fatalf("Unknown command: %s\n", command)
	}
	// app := cli.NewApp()
	// app.Name = "Rainforest CLI"
	// app.Usage = "Command line utility for Rainforest QA"
	//
	// app.Flags = []cli.Flag{
	// 	cli.StringSliceFlag{
	// 		Name:  "tags",
	// 		Usage: "Filter tests by tag",
	// 	},
	// 	cli.StringFlag{
	// 		Name:  "token",
	// 		Usage: "Rainforest API token",
	// 	},
	// 	cli.IntFlag{
	// 		Name:  "smart-folder-id",
	// 		Usage: "Specify a folder of tests in Rainforest",
	// 	},
	// }
	//
	// app.Commands = []cli.Command{
	// 	{
	// 		Name:  "run",
	// 		Usage: "Run your tests on Rainforest",
	// 		Action: func(c *cli.Context) error {
	// 			apiToken = c.String("token")
	// 			createRun(c)
	// 			return nil
	// 		},
	// 	},
	//
	// 	{
	// 		Name:  "folders",
	// 		Usage: "Retreive folders on Rainforest",
	// 		Action: func(c *cli.Context) error {
	// 			apiToken = c.String("token")
	// 			printFolders()
	// 			return nil
	// 		},
	// 	},
	// 	{
	// 		Name:  "sites",
	// 		Usage: "Retreive sites on Rainforest",
	// 		Action: func(c *cli.Context) error {
	// 			apiToken = c.String("token")
	// 			printSites()
	// 			return nil
	// 		},
	// 	},
	//
	// 	{
	// 		Name:  "browsers",
	// 		Usage: "Retreive sites on Rainforest",
	// 		Action: func(c *cli.Context) error {
	// 			apiToken = c.String("token")
	// 			printBrowsers()
	// 			return nil
	// 		},
	// 	},
	// }
	// app.Run(os.Args)
}
