import sys

# Author: Abdul Azeez Omar
# File: convert.py
# Purpose: This script gets invoked when the user asks for an exe file which prepares the shellcode in a C file with a good format to get compiled later with wclang

# this script iterates over the bytes of the shellcode and convert it to big endian hex data. Then it creates a new ld.c file containing the shellcode with format: unsigned char buf [] = "shellcode_here";
ch = open(sys.argv[1]).read()
res = ""
for i in ch:
	res += "\\" + "x" + hex(ord(i))[2:].rjust(2,"0")
size = len(ch)
payload = ""
payload += "unsigned char buf [] = "
payload += '"' + res + '"'
payload += ";"
open("/root/PEPWN/ld.c","w").write(payload)

