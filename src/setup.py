
# Author: Abdul Azeez Omar
# File: setup.py
# Purpose: This script handles the preparation of the c++ file for compilation. It changes the size of the shellcode in the c++ file and invokes the convert.py script that will prepare the shellcode in "ld.c" file.


import subprocess
import sys
import os
print sys.argv[1]
# this script is called when there's a request for and EXE file in the command. it apply second layer of encoding using sgn
out = subprocess.Popen(["sgn",sys.argv[1]], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
stdout,stderr = out.communicate()
print stdout
size = int(stdout.split("Final size: ")[1].split("\n")[0])   #it gets the size of the output file from sgn's output
print size
ch = open("/root/PEPWN/src/temp.cc").read()                  # it opens the template c++ file and reads its content
ch = ch.replace("{size_here}",str(size))                     # it replaces the size in the tempalte file with the size extracted from sgn's output
open("/root/PEPWN/src.cc","w").write(ch)                     # then create a new c++ file that is ready to et compiled
os.system("python ~/PEPWN/src/convert.py ~/PEPWN/load.sgn")  # generate the header file needed for the compilation that contains the shellcode
os.system("rm ~/PEPWN/load.sgn")                             #remove the not needed files.
