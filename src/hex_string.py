import sys

# Author: Abdul Azeez Omar
# File: hex_string.py
# Purpose: This script iterates over the bytes of shellcode file given as argument and transfers it from bytes to big endian hex data. For example if the bytes are ABCD it'll become "\x41\x42\x43\x44" .


# this lopp iterates over all the bytes of the shellcode as raw data and transfer it to big endian hex string. for example(\x01\x02\x03)
ch = open(sys.argv[1]).read()
res = ""
for i in ch:
        res += "\\" + "x" + hex(ord(i))[2:].rjust(2,"0")
open("/tmp/res.hex","w").write(res)  #save the result in /tmp
