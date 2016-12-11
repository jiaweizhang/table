package main

import (
	"fmt"
	"os"
	"strings"
	"strconv"
)

var f, err = os.Create("../mem.mif")
var counter = 0

func main() {
	check(err)

	defer f.Close()

	f.WriteString("WIDTH=128;\n")
	f.WriteString("DEPTH=1024;\n")
	f.WriteString("\n");
	f.WriteString("ADDRESS_RADIX=DEC;\n")
	f.WriteString("DATA_RADIX=BIN;\n")
	f.WriteString("\n")
	f.WriteString("CONTENT BEGIN\n")
	c(15, 20, "1000", "1111", true, true)
	c(30, 15, "0100", "1000", true, false)
	c(45, 15, "0010", "1000", true, false)
	c(15, 30, "0001", "0100", true, false)
	c(60, 15, "0100", "0001", true, false)
	c(75, 14, "0010", "1111", true, true)
	c(100, 100, "1000", "1111", true, true)
	c(101, 100, "1000", "1000", true, false)
	c(102, 101, "1000", "1000", true, false)
	c(103, 102, "1000", "1000", true, false)
	c(104, 103, "1000", "1000", true, false)
	c(105, 104, "1000", "1000", true, false)
	c(106, 105, "1000", "1000", true, false)
	c(107, 106, "1000", "1000", true, false)
	c(108, 107, "1000", "1000", true, false)
	c(109, 108, "1000", "1000", true, false)
	c(110, 109, "1000", "1000", true, false)
	c(111, 110, "1000", "1000", true, false)
	c(112, 111, "1000", "1000", true, false)
	c(113, 112, "1000", "1000", true, false)
	c(114, 113, "1000", "1000", true, false)
	c(115, 114, "1000", "1000", true, false)
	c(116, 115, "1000", "1000", true, false)
	c(117, 116, "1000", "1000", true, false)
	c(118, 117, "1000", "1000", true, false)
	c(119, 118, "1000", "1000", true, false)
	c(120, 119, "1000", "1000", true, false)
	c(121, 120, "1000", "1000", true, false)
	c(122, 121, "1000", "1000", true, false)
	c(123, 122, "1000", "1000", true, false)
	c(124, 123, "1000", "1000", true, false)
	c(125, 124, "1000", "1000", true, false)
	c(126, 125, "1000", "1000", true, false)
	c(127, 126, "1000", "1000", true, false)
	c(128, 127, "1000", "1000", true, false)
	c(129, 128, "1000", "1000", true, false)
	c(130, 129, "1000", "1000", true, false)
	c(131, 130, "1000", "1000", true, false)
	c(132, 131, "1000", "1000", true, false)
	c(133, 132, "1000", "1000", true, false)
	c(134, 100, "1000", "1111", true, true)
	c(133, 133, "1000", "1000", true, false)
	c(133, 133, "1000", "1000", true, false)
	c(133, 133, "1000", "1000", true, false)
	c(133, 133, "1000", "1000", true, false)
	c(133, 133, "1000", "1000", true, false)

	f.WriteString("\n")
	f.WriteString("END\n")
	fmt.Println("complete")
}

func c(sourceAddress int, destinationAddress int, sourcePort string, destinationPort string, access bool, notFound bool) {
	str := fmt.Sprintf("%22b%1b%1b%4s%4s%16b%32b%16b%32b", 0, ter(notFound), ter(access), destinationPort, sourcePort, 0, destinationAddress, 0, sourceAddress)
	f.WriteString(strconv.Itoa(counter) + " : " + r(str) + ";\n")
	counter++
}

func ter(boolean bool) int {
	if (boolean) {
		return 1
	} else {
		return 0
	}
}

func r(str string) string {
	return strings.Replace(str, " ", "0", -1)
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}