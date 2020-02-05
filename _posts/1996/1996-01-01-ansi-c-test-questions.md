---
layout: default
title: ANSI C Test Questions
tags: ansi c test
comments: true
---
# ANSI C Test Questions

See answers below.

1. Pointer arguments are passed to a function by  
    a. Value  
    b. Reference  
    c. Global variable  
    d. Static variable  

2. To pass an array as a parameter to a function, we pass it by  
    a. Value  
    b. Static variable  
    c. Global variable  
    d. Reference  

3. Portability in C is  
    a. The ability to run the executable of one system in another  
    b. The ability to compile successfully the same source code in different systems  
    c. The fact that both the systems have, possibly incompatible, C compilers  

4. The sizes of `char`, `int` and `float` are, respectively  
    a. 2, 4, and 8 bytes  
    b. 1, 2, and 4 bytes  
    c. 1, 2, and 2 bytes  
    d. 2, 4, and 4 bytes  

5. Structures and Unions are equivalent  
    a. True  
    b. False  

6. A structure and a union, both have the same members. Then  
    a. The structure occupies less space than the union.  
    b. The union occupies less space than the structure.  
    c. Both occupy equal space.  

7. The amount of space allocated in bytes for `union cmplx {float x,float y,int i};` is  
    a. 4  
    b. 2  
    c. 10  
    d. 6  

8. The maximum positive value that can be stored in a `long` is  
    a. `2^32 - 1`  
    b. `2^16 - 1`  
    c. `2^(32-1) - 1`  
    d. `2^(16-1) - 1`  

9. High precision scientific calculations involving a space expedition are being performed. The preferred data type must probably be  
    a. `long`  
    b. `float`  
    c. `unsigned`  
    d. `double`  

10. `printf("The world\n\0is round");` will display the message  
    a. The world  
    b. The world is round  
    c. The world  
       is round  

11. If you want to read a string of words you can use the function  
    a. `scanf`  
    b. `getch`  
    c. `gets`  
    d. `getchar`  

12. `double` is used instead of `float` because  
    a. float has less significant digits  
    b. double has a large mantissa  
    c. double has a smaller exponent  
    d. Both a and b  

13. if `var` is a variable then `&var` is its  
    a. pointer  
    b. value  
    c. type  
    d. inverse  

14. If `ptr` is a pointer and `val` is a variable, which of the following is a valid indirection  
    a. `ptr = val;`  
    b. `ptr = *val;`  
    c. `&ptr = val;`  
    d. `ptr = &val;`  

15. If `arr[10]` is an array of `int` then which of the following accesses array index 1  
    a. `printf("%d", 1[arr]);`  
    b. `printf("%d", *(arr+=1));`  
    c. `printf("%d", arr[1]);`  
    d. all of the above  
    e. only a and c above  

16. The string `"hello world"` needs how many bytes for storage  
    a. 11  
    b. 13  
    c. 12  
    d. 10  

17. The last byte of the string `"Internet is big"` is  
    a. EOL  
    b. `0`  
    c. `'g'`  
    d. EOF  

18. The result of `255 & 16` is  
    a. 255  
    b. 0  
    c. `020`  
    d. `0x8`  

19. The result of `19%3` is  
    a. 6  
    b. 18  
    c. 0  
    d. 1  

20. A header file is  
    a. a machine code file  
    b. a file containing source code of library functions  
    c. a file containing prototype declarations  
    d. both b and c  

21. A register variable is mostly used for  
    a. loops and counters  
    b. passing parameters to functions  
    c. calling interrupt service routines  
    d. saving registers to stack  

22. The first step in generation of executable file from C file is  
    a. Compiling  
    b. Linking  
    c. Pre-processing  
    d. Loading  

23. To access a variable declared in another module of a big program we use storage class  
    a. `auto`  
    b. `static`  
    c. `register`  
    d. `extern`  

24. When a file is opened, the file descriptor is assigned by  
    a. the compiler  
    b. the operating system  
    c. the user  
    d. the loader  

25. To redirect stdout to a file, the function that may be used is  
    a. `open`  
    b. `fopen`  
    c. `creat`  
    d. `freopen`  

26. The default value returned by a function having no prototype is assumed by ANSI C to be  
    a. `void`  
    b. `char`  
    c. `int`  
    d. `float`  

27. In ANSI C, the generic pointer type is  
    a. pointer to void  
    b. pointer to char  
    c. pointer to int  
    d. pointer to float  

28. Macro definitions in C are done by  
    a. `#if`  
    b. `#include`  
    c. `const`  
    d. `#define`  

29. If a local variable must remember its previous value in a function it must be declared using the class  
    a. `auto`  
    b. `extern`  
    c. `register`  
    d. `static`  

30. `sizeof` is a  
    a. C library function  
    b. Reserved word  
    c. Operator  
    d. Both b and c  

31. `h` is a pointer to pointer to `int` and points to `p`, a pointer to `int`. If `p` points to a value `4` then `*h` is  
    a. the `int` 4  
    b. the address of `p`  
    c. the address of `h`  
    d. the address of value 4  

32. To dynamically allocate 100 locations each of type `double` which of the following is correct  
    a. `calloc(100,8)`  
    b. `calloc(8,100)`  
    c. `(double *)malloc(100)`  
    d. `calloc(800)`  

33. Which of the following are reserved words  
    a. `static`  
    b. `while`  
    c. `return`  
    d. all of the above  

34. C was originally developed by  
    a. Ken Thompson and Dennis Ritchie  
    b. Dennis Ritchie and Brian Kernighan  
    c. Ken Thompson and Brian Kernighan  
    d. Niklaus Wirth and Dennis Ritchie  

35. Variables can begin with  
    a. Underscore  
    b. Digit  
    c. Hyphen  
    d. None of the above  

36. The value of `a-b`, assuming `a=0x0A` and `b=012` is  
    a. 2  
    b. -2  
    c. 0  
    d. none of the above  

37. Variables are initialized to zero for storage classes  
    a. Auto and Static  
    b. Extern and Static  
    c. Static and Register  
    d. Register and Auto  

38. The output resulting from `i=10; printf("%d --- %d",i,i++);` is  
    a. `10 --- 11`  
    b. `10 --- 10`  
    c. `11 --- 10`  
    d. `11 --- 11`  

39. For `char c=127; printf("%d",++c);` the output is  
    a. 128  
    b. 127  
    c. 0  
    d. -128  

40. For `int a=30*1000+2768; printf("%d",a);` the output is  
    a. 0  
    b. 1  
    c. -1  
    d. None of the above  

41. For `int a=244; if(a=400) printf("50th Independence Day");`  
    a. The output is `50th Independence Day`  
    b. There will be no output because a is not 400  

42. `if('X' < 'x'); printf("50th Independence Day");`  
    a. The output is `50th Independence Day`  
    b. There will be no output  

43. Which is the odd one out  
    a. `a++`  
    b. `a+=1`  
    c. `a=+1`  
    d. `a=a+1`  

44. `for(;;)`  
    a. is an illegal statement  
    b. is legal but the result is unpredictable  
    c. is illegal in ANSI C but legal in Turbo C  
    d. is legal and the result is predictable  

45. Which of the following is not a C keyword  
    a. `switch`  
    b. `case`  
    c. `choice`  
    d. `break`  

46. `int i; char c;` then which of the following is lossless  
    a. `i=c;c=i;`  
    b. `c=i;i=c;`  

47. if `p` and `q` are two pointers then which of the following is illegal  
    a. `p=q`  
    b. `p-q`  
    c. `p+q`  
    d. `p=q+1`  

48. Values assigned to enum constants cannot be the same i.e. `enum colors {BLUE=1,RED=1,GREEN=1,CYAN=2,MAGENTA=2,YELLOW=2}` is invalid  
    a. True  
    b. False  

49. In `int (*a)[13]`
    a. `a` is a pointer  
    b. `a` is an integer  
    c. `a` is an array  
    d. `a` is a function  

50. `a[i][j]` is same as  
    a. `a+i+j`  
    b. `&((a+i)+j)`  
    c. `*(*(a+i)+j)`  
    d. None of the above  

51. If `p` is a pointer, which of the following is invalid  
    a. `p[-2]`  
    b. `p-2`  
    c. `p*2`  
    d. `p=0`  

52. In functions using C calling convention, stack cleanup is done by  
    a. Called function  
    b. Calling function  
    c. Operating system  

53. In functions using Pascal calling convention, stack cleanup is done by  
    a. Called function  
    b. Calling function  
    c. Operating system  

54. Which of the following is not `true`  
    a. Variable declarations allocate storage for variables  
    b. Variable definitions allocate storage for variables  

55. Which of the following is not recursion  
    a. f1 calling f2 and f2 calling f1  
    b. f1 calling itself  
    c. main calling main  
    d. all of the above are recursion  

56. Select the odd one  
    a. `a+a+a+a`  
    b. `a<<2`  
    c. `a*4`  
    d. `a>>4`  

57. What is the size in bytes of the value `23L + 32U`  
    a. 2  
    b. 4  
    c. 8  
    d. none of the above  

58. Operator `*` when used with pointers is called the  
    a. indirection operator  
    b. referencing operator  

59. For declaration `int (*a)[10];` and assuming `a=100`, the output for `printf("%p",a+1);` is  
    a. 102  
    b. 104  
    c. 120  
    d. 110  

60. Which of the following is invalid  
    a. `int a[2][2] = { {11, 12}, {21, 22} };`  
    b. `int a[][2] = { {11, 12}, {21, 22} };`  
    c. `int a[2][] = { {11, 12}, {21, 22} };`  
    d. both b and c above  

61. For `char *s = "SNAIL"; (*(s+5))?printf("SNAIL"):printf("HARE");` the output is  
    a. `SNAIL`  
    b. `HARE`  

62. If `s` is a struct and `p` a pointer to it, so that `p=&s` then which of the following is the correct way to read a field `fieldname` in the struct  
    a. `p.fieldname`  
    b. `(*p).fieldname`  
    c. `s->fieldname`  
    d. all of the above  

63. If we have an executable program `prog.exe`, and text file f1 then typing `prog < f1` at DOS prompt means  
    a. The screen is temporarily redundant  
    b. The keyboard is temporarily redundant  
    c. Both screen and keyboard are temporarily redundant  
    d. The command is illegal  

64. Which of the following are standard files in C  
    a. stdprn  
    b. stdout, stdin and stderr  
    c. stdaux  
    d. all of the above  

65. Which of the following is not a valid function in C  
    a. `cscanf`  
    b. `sscanf`  
    c. `fscanf`  
    d. `pscanf`  

66. With which of the following file I/O type is the buffer management transparent  
    a. high level  
    b. low level  

67. To which of the following file I/O level do `fwrite` and `fread` belong  
    a. high level  
    b. low level  

68. The statement `#define NULL 0` is in the header file  
    a. `conio.h`  
    b. `stdio.h`  
    c. `file.h`  
    d. `limits.h`  

69. Given `enum days = {mon,tue,wed,thu,fri,sat,sun}`  
    The output of `printf("%d",mon+sun);` is  
    a. 7  
    b. 6  
    c. 8  
    d. none of the above  

70. In C convention, the order of passing multiple parameters to a function occurs from  
    a. left to right with first parameter on top of stack  
    b. right to left with first parameter on top of stack  
    c. left to right with last parameter on top of stack  
    d. right to left with last parameter on top of stack  

71. Consider the following piece of code `if(i = 10 > 5); printf("%d",i);`  
    The output is  
    a. 0  
    b. 1  
    c. Garbage value  
    d. None of the above  

## Answers

1a  2d  3b  4b  5b  6b  7a  8c  9d  10a  11c  12d  13a  14d  15e  16c  17b  18c  19d  20c  21a  22c  23d  24b  25d  26c  27a  28d  29d  30d  31d  32a  33d  34b  35a  36c  37b  38c  39d  40d  41a  42a  43c  44d  45c  46a  47c  48b  49a  50c  51c  52b  53a  54a  55d  56d  57b  58a  59c  60c  61b  62b  63b  64d  65d  66a  67a  68b  69b  70b  71b  
