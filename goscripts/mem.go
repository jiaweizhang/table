package main

import (
	"fmt"
	"os"
	"strings"
)

var f, err = os.Create("data/mem.mif")

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
	f.WriteString("\n")
	f.WriteString("END\n")
	fmt.Println("complete")
}

func c(sourceAddress int, destinationAddress int, sourcePort string, destinationPort string, access bool, notFound bool) {
	str := fmt.Sprintf("%22b%1b%1b%4s%4s%16b%32b%16b%32b", 0, ter(notFound), ter(access), destinationPort, sourcePort, 0, destinationAddress, 0, sourceAddress)
	f.WriteString(r(str) + "\n")
	fmt.Println(len(str))
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