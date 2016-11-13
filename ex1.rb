def translate(vm_path, asm_path)
  if !File.file?(vm_path)
    puts('VM File does not exists!')
    return
  end
  lines = IO.readlines(vm_path)
  #TODO: remove next row - init
  #TODO: replace @99 with @SP
  output = "@256\nD=A\n@99\nM=D\n"
  for line in lines
    line = line.split
      case line[0]
        when 'add'
          output << add
        when 'sub'
          output << sub
        when 'neg'
          output << neg
        when 'eq'
          output << eq
        when 'gt'
          output << gt
        when 'lt'
          output << lt
        when 'and'
          output << f_and
        when 'or'
          output << f_or
        when 'not'
          output << f_not
        when 'push'
          output << push(line[1], line[2])
        when 'pop'
          output << pop(line[1], line[2])
      end
  end
  puts(output)
  File.open(asm_path, 'w') do |f|
    f.puts(output)
  end
end

def pre_binary
  output = "@99\n" #get 99 into A
  output << "M=M-1\n" #decrease 99 by 1
  output << "A=M\n" #point to the new 99
  output << "D=M\n" #pop the previous variable to D register
  output << "A=A-1\n" #decrease 99 by 1
  return output
end

def pre_unary
  output = "@99\n" #get 99 into A
  output << "M=M-1\n" #decrease 99 by 1
  output << "A=M\n" #point to the new 99
  return output
end

def add
  output = "\n//add\n"
  output << pre_binary
  output << "M=M+D\n" #insert into stack top D + current stack top
  return output
end

def sub
  output = "\n//sub\n"
  output << pre_binary
  output << "M=M-D\n" #insert into stack top D - current stack top
  return output
end

def neg
  output = "\n//neg\n"
  output << pre_unary
  output << "M=-M" #update stack top to it's negative
  return output
end

def eq
  output = "\n//eq\n"
  return output
end

def gt
  output = "\n//gt\n"
  return output
end

def lt
  output = "\n//lt\n"
  return output
end

def f_and
  output = "\n//f_and\n"
  output << pre_binary
  output << "M=M&D\n"
  return output
end

def f_or
  output = "\n//f_or\n"
  output << pre_binary
  output << "M=M|D\n"
  return output
end

def f_not
  output = "\n//f_not\n"
  output << pre_unary
  output << "M=!M\n"
  return output
end

def push(segment, index)
  output = "\n//push"
  output << ' segment: ' << segment
  output << ' index: ' << index << "\n"
  case segment
    when 'constant'
      output << push_constant(index)
  end
  return output
end

def pop(segment, index)
  output = "\n//pop"
  output << ' segment: ' << segment
  output << ' index: ' << index
  output << "\n"
  return output
end

def push_constant(index)
  output = '@' << index << "\n"
  output << "D=A\n"
  output << "@99\n"
  output << "A=M\n"
  output << "M=D\n"
  output << "D=A+1\n"
  output << "@99\n"
  output << "M=D\n"
  return output
end
translate(ARGV[0], ARGV[1])

