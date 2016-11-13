$label_counter = 1
def translate(vm_path, asm_path)
  if !File.file?(vm_path)
    puts('VM File does not exists!')
    return
  end
  lines = IO.readlines(vm_path)
  #TODO: remove next row - init
  #TODO: replace @99 with @SP
  #TODO: extract to functions
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

def pop_and_point_to_prev
  output = "@99\n" #get SP into A
  output << "M=M-1\n" #decrease SP by 1
  output << "A=M\n" #point to the new SP
  output << "D=M\n" #pop the previous variable to D register
  output << "A=A-1\n" #decrease SP by 1
  return output
end

def pre_unary
  output = "@99\n" #get SP into A
  output << "A=M-1\n"
  return output
end

def add
  output = "\n//add\n"
  output << pop_and_point_to_prev
  output << "M=M+D\n" #insert into stack top D + current stack top
  return output
end

def sub
  output = "\n//sub\n"
  output << pop_and_point_to_prev
  output << "M=M-D\n" #insert into stack top D - current stack top
  return output
end

def neg
  output = "\n//neg\n"
  output << pre_unary
  output << "M=-M\n" #update stack top to it's negative
  return output
end

def eq
  output = "\n//eq\n"
  output << pop_and_point_to_prev
  output << "A=M\n" #in D there is the first arg, in A the second
  output << "D=A-D\n" #if D and A are equal = D is 0.
  output << '@IF_TRUE' << $label_counter.to_s << "\n"
  output << "D;JEQ\n"
  output << "@99\n"
  output << "A=M-1\n"
  output << "M=0\n"
  output << '@END' << $label_counter.to_s << "\n"
  output << "0;JEQ\n"
  output << '(IF_TRUE' << $label_counter.to_s << ")\n"
  output << "@99\n"
  output << "A=M-1\n"
  output << "M=-1\n"
  output << '(END' << $label_counter.to_s << ")\n"
  $label_counter = $label_counter + 1
  return output
end

def gt
  output = "\n//gt\n"
  output << pop_and_point_to_prev
  output << "A=M\n" #in D there is the first arg, in A the second
  output << "D=A-D\n" #if D and A are equal = D is 0.
  output << '@IF_TRUE' << $label_counter.to_s << "\n"
  output << "D;JGT\n"
  output << "@99\n"
  output << "A=M-1\n"
  output << "M=0\n"
  output << '@END' << $label_counter.to_s << "\n"
  output << "0;JEQ\n"
  output << '(IF_TRUE' << $label_counter.to_s << ")\n"
  output << "@99\n"
  output << "A=M-1\n"
  output << "M=-1\n"
  output << '(END' << $label_counter.to_s << ")\n"
  $label_counter = $label_counter + 1
  return output
end

def lt
  output = "\n//lt\n"
  output << pop_and_point_to_prev
  output << "A=M\n" #in D there is the first arg, in A the second
  output << "D=A-D\n" #if D and A are equal = D is 0.
  output << '@IF_TRUE' << $label_counter.to_s << "\n"
  output << "D;JLT\n"
  output << "@99\n"
  output << "A=M-1\n"
  output << "M=0\n"
  output << '@END' << $label_counter.to_s << "\n"
  output << "0;JEQ\n"
  output << '(IF_TRUE' << $label_counter.to_s << ")\n"
  output << "@99\n"
  output << "A=M-1\n"
  output << "M=-1\n"
  output << '(END' << $label_counter.to_s << ")\n"
  $label_counter = $label_counter + 1
  return output
end

def f_and
  output = "\n//f_and\n"
  output << pop_and_point_to_prev
  output << "M=M&D\n"
  return output
end

def f_or
  output = "\n//f_or\n"
  output << pop_and_point_to_prev
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
    when 'local'
      output << push_local(index)
  end
  return output
end

def pop(segment, index)
  output = "\n//pop"
  output << ' segment: ' << segment
  output << ' index: ' << index
  output << "\n"
  case segment
    when 'local'
      output << pop_local(index)
  end
  return output
end

def push_constant(index)
  output = '@' << index << "\n"
  output << "D=A\n"
  output << push_from_D
  return output
end

def push_local(index)
  output = "@1\n" #LCL = 1
  output << "D=M\n" #D = RAM[1]
  output << 'A=D+' << index << "\n" #A = RAM[1] + index
  output << "D=M\n" #D = RAM[RAM[1] + index]
  output << push_from_D
  return output
end

def pop_local(index)

end

def push_from_D
  output = "@99\n"
  output << "A=M\n"
  output << "M=D\n"
  output << "D=A+1\n"
  output << "@99\n"
  output << "M=D\n"
end

translate(ARGV[0], ARGV[1])

