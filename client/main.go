package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"strings"

	"github.com/bradfitz/gomemcache/memcache"
)

type node struct {
	host string
	ip   string
	port string
}
type nodes []node

func (n nodes) ToString() []string {
	nodes := make([]string, 0)
	for _, node := range n {
		nodes = append(nodes, fmt.Sprintf("%s:%s", node.host, node.port))
	}

	return nodes
}

var configEndpoint = flag.String("c", "", "configuration endpoint")
var method = flag.String("m", "", "method GET, SET")

func main() {
	flag.Parse()

	nodes := getNodes(*configEndpoint)
	fmt.Println("Fetched Nodes from configuration endpoint", nodes)

	mc := memcache.New(nodes.ToString()...)

	if *method == "GET" {
		get(mc)
	} else {
		set(mc)
	}
}

func get(mc *memcache.Client) {
	item, err := mc.Get("increment")
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Current Value: ", item)
	}
}

func set(mc *memcache.Client) {
	newValue, err := mc.Increment("increment", 1)
	if err != nil {
		fmt.Println(err)

		// cache item does not exist, create
		if err == memcache.ErrCacheMiss {
			err := mc.Set(&memcache.Item{Key: "increment", Value: []byte("1")})
			if err != nil {
				fmt.Println(err)
			}

			newValue = 1
		}
	}

	fmt.Println("New value: ", newValue)
}

func getNodes(endpoint string) nodes {
	conn, err := net.Dial("tcp", endpoint)
	if err != nil {
		panic(err)
	}
	defer conn.Close()

	command := "config get cluster\r\n"
	fmt.Fprintf(conn, command)

	response, err := parseResponse(conn)
	if err != nil {
		log.Fatal(err)
	}

	return parseNodes(response)
}

func parseResponse(conn io.Reader) (string, error) {
	var response string

	count := 0
	location := 3 // AWS docs suggest that nodes will always be listed on line 3

	scanner := bufio.NewScanner(conn)
	for scanner.Scan() {
		count++
		if count == location {
			response = scanner.Text()
		}
		if scanner.Text() == "END" {
			break
		}
	}

	if err := scanner.Err(); err != nil {
		return "", err
	}

	return response, nil
}

func parseNodes(response string) []node {
	nodes := make([]node, 0)

	lines := strings.Split(response, " ")
	for _, line := range lines {
		elements := strings.Split(line, "|")
		nodes = append(nodes,
			node{
				host: elements[0],
				ip:   elements[1],
				port: elements[2],
			})
	}

	return nodes
}
