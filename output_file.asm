@256
D=A
@99
M=D

//push segment: constant index: 3030
@3030
D=A
@99
A=M
M=D
D=A+1
@99
M=D

//pop segment: pointer index: 0
@99
M=M-1
A=M
D=M
A=A-1
@3
M=D

//push segment: constant index: 3040
@3040
D=A
@99
A=M
M=D
D=A+1
@99
M=D

//pop segment: pointer index: 1
@99
M=M-1
A=M
D=M
A=A-1
@4
M=D

//push segment: constant index: 32
@32
D=A
@99
A=M
M=D
D=A+1
@99
M=D

//pop segment: this index: 2
@3
D=M
@2
D=D+A
@13
M=D
@99
M=M-1
A=M
D=M
A=A-1
@13
A=M
M=D

//push segment: constant index: 46
@46
D=A
@99
A=M
M=D
D=A+1
@99
M=D

//pop segment: that index: 6
@4
D=M
@6
D=D+A
@13
M=D
@99
M=M-1
A=M
D=M
A=A-1
@13
A=M
M=D

//push segment: pointer index: 0
@3
D=M
@99
A=M
M=D
D=A+1
@99
M=D

//push segment: pointer index: 1
@4
D=M
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

//push segment: this index: 2
@3
D=M
@2
A=D+A
D=M
@99
A=M
M=D
D=A+1
@99
M=D

//sub
@99
M=M-1
A=M
D=M
A=A-1
M=M-D

//push segment: that index: 6
@4
D=M
@6
A=D+A
D=M
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
