### About this project

Designed and wrote a 64 bit NASM program `fproj.asm` that behaves like the python program `fproj.py`.
The program computes the `border array` of the input string and displays it in a simple way (as an array of numbers), and in a fancy way (as a bar diagram), see the python program `fproj.py`.

Given a string as an input, we look at whether a substring is a prefix and a suffix in a string. The string `ababbcd` does not have a border, `ababbca` has a border `a`, the string `abab` has a border `ab`, while ababa has a border `a`, and also `aba` .

### Worked example

The border array `bordar[0..n‑1]` of a string `x[0..n‑1]` is an array of size `n` , where `bordar[i]` = size of the maximal border of the string `x[i..n-1]` . For example, for `abcdabcdab`, the maximal border for `abcdabcdab` is `abcdab`, and so `bordar[0] = 6` . For `bcdabcdab`, the maximal border is `bcdab` , and so `bordar[1] = 5` . For `cdabcdab` , the maximal border is `cdab` , and so `bordar[2] = 4` . For `dabcdab` , the maximal border is `dab` , and so `bordar[3] = 3` . For `abcdab` , the maximal border is `ab` , and so `bordar[4] = 2` . For `bcdab` , the maximal border is `b` , and so `bordar[5] = 1` . For `cdab` , there is no border, and so `bordar[6] = 0` . For `dab` , there is no border, and so `bordar[7] = 0` . For `ab` , there is no border, and so `bordar[8] = 0` . For `b` , there is no border, and so `bordar[9] = 0` . Thus, the border array of `abcdabcdab` is `6,5,4,3,2,1,0,0,0,0` .

### Run locally

 - The python file can be run using the command `python3 fproj.py <string>`
 
 - The NASM file needs to be run with the following steps:
   - You will need the supporting files `driver.c`, `simple_io.inc`, `simple_io.asm`  to compile and execute your program.
   - On your terminal run `make fproj` and then `./fproj <string>`





