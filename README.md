# PEPWN
PWNPE is a multi chained tool that has a goal to generate an undetectable reverse shell payload in different formats (PE, shellcode). The payload is stageless and it works without the need of Metasploit Handler, it just needs a TCP listener (using netcat).


# Overview

1- generate a payload with msfvenom.
2- generate a shellcode from it
3- encodes it.
4- apply 2nd layer of encoding using sgn.
5- transfer it into a shellcode format of use or create exe file that triggers that shellcode using syscalls.



# Installation

Go to /root directory 

git clone https://github.com/0xx7/PEPWN.git



./build.sh

then 

./wrapper -H


# How to use

vidoe 
