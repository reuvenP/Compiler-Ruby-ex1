@256
D=A
@99
M=D

//push segment: constant index: 7
@7
D=A
@99
A=M
M=D
D=A+1
@99
M=D

//push segment: constant index: 8
@8
D=A
@99
A=M
M=D
D=A+1
@99
M=D

//add
@99
M=M-1
A=M
D=M
A=A-1
M=M+D

//push segment: constant index: 15
@15
D=A
@99
A=M
M=D
D=A+1
@99
M=D

//eq
@99
M=M-1
A=M
D=M
A=A-1
A=M
D=A-D
@TRUE1
D;JEQ
@99
A=M-1
M=0
@FALSE1
0;JEQ
(TRUE1)
@99
A=M-1
M=-1
(FALSE1)
