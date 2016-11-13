@256
D=A
@99
M=D

//push segment: constant index: 9
@9
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

//lt
@99
M=M-1
A=M
D=M
A=A-1
A=M
D=A-D
@IF_TRUE1
D;JLT
@99
A=M-1
M=0
@END1
0;JEQ
(IF_TRUE1)
@99
A=M-1
M=-1
(END1)
