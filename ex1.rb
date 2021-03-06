$label_counter = 1
def translate_file(vm_path)
  if !File.file?(vm_path)
    return 'VM File does not exists!'
  end
  lines = IO.readlines(vm_path)
  output = ''
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
          output << push(line[1], line[2], vm_path)
        when 'pop'
          output << pop(line[1], line[2], vm_path)
      end
  end
  return output
end

def pop_to_D
  output = "@SP\n" #get SP into A
  output << "M=M-1\n" #decrease SP by 1
  output << "A=M\n" #point to the new SP
  output << "D=M\n" #pop the previous variable to D register
  output << "A=A-1\n" #decrease SP by 1
  return output
end

def pre_unary
  output = "@SP\n" #get SP into A
  output << "A=M-1\n"
  return output
end

def add
  output = "\n//add\n"
  output << pop_to_D
  output << "M=M+D\n" #insert into stack top D + current stack top
  return output
end

def sub
  output = "\n//sub\n"
  output << pop_to_D
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
  output << pop_to_D
  output << "A=M\n" #in D there is the first arg, in A the second
  output << "D=A-D\n" #if D and A are equal = D is 0.
  output << '@IF_TRUE' << $label_counter.to_s << "\n"
  output << "D;JEQ\n"
  output << "@SP\n"
  output << "A=M-1\n"
  output << "M=0\n"
  output << '@END' << $label_counter.to_s << "\n"
  output << "0;JEQ\n"
  output << '(IF_TRUE' << $label_counter.to_s << ")\n"
  output << "@SP\n"
  output << "A=M-1\n"
  output << "M=-1\n"
  output << '(END' << $label_counter.to_s << ")\n"
  $label_counter = $label_counter + 1
  return output
end

def gt
  output = "\n//gt\n"
  output << pop_to_D
  output << "A=M\n" #in D there is the first arg, in A the second
  output << "D=A-D\n" #if D and A are equal = D is 0.
  output << '@IF_TRUE' << $label_counter.to_s << "\n"
  output << "D;JGT\n"
  output << "@SP\n"
  output << "A=M-1\n"
  output << "M=0\n"
  output << '@END' << $label_counter.to_s << "\n"
  output << "0;JEQ\n"
  output << '(IF_TRUE' << $label_counter.to_s << ")\n"
  output << "@SP\n"
  output << "A=M-1\n"
  output << "M=-1\n"
  output << '(END' << $label_counter.to_s << ")\n"
  $label_counter = $label_counter + 1
  return output
end

def lt
  output = "\n//lt\n"
  output << pop_to_D
  output << "A=M\n" #in D there is the first arg, in A the second
  output << "D=A-D\n" #if D and A are equal = D is 0.
  output << '@IF_TRUE' << $label_counter.to_s << "\n"
  output << "D;JLT\n"
  output << "@SP\n"
  output << "A=M-1\n"
  output << "M=0\n"
  output << '@END' << $label_counter.to_s << "\n"
  output << "0;JEQ\n"
  output << '(IF_TRUE' << $label_counter.to_s << ")\n"
  output << "@SP\n"
  output << "A=M-1\n"
  output << "M=-1\n"
  output << '(END' << $label_counter.to_s << ")\n"
  $label_counter = $label_counter + 1
  return output
end

def f_and
  output = "\n//f_and\n"
  output << pop_to_D
  output << "M=M&D\n"
  return output
end

def f_or
  output = "\n//f_or\n"
  output << pop_to_D
  output << "M=M|D\n"
  return output
end

def f_not
  output = "\n//f_not\n"
  output << pre_unary
  output << "M=!M\n"
  return output
end

def push(segment, index, path)
  output = "\n//push"
  output << ' segment: ' << segment
  output << ' index: ' << index << "\n"
  case segment
    when 'constant'
      output << push_constant(index)
    when 'local'
      output << push_local(index)
    when 'argument'
      output << push_argument(index)
    when 'this'
      output << push_this(index)
    when 'that'
      output << push_that(index)
    when 'temp'
      output << push_temp(index)
    when 'static'
      output << push_static(index, path)
    when 'pointer'
      output << push_pointer(index)
  end
  return output
end

def pop(segment, index, path)
  output = "\n//pop"
  output << ' segment: ' << segment
  output << ' index: ' << index
  output << "\n"
  case segment
    when 'local'
      output << pop_local(index)
    when 'argument'
      output << pop_argument(index)
    when 'this'
      output << pop_this(index)
    when 'that'
      output << pop_that(index)
    when 'temp'
      output << pop_temp(index)
    when 'static'
      output << pop_static(index, path)
    when 'pointer'
      output << pop_pointer(index)
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
  output << '@' << index << "\n" #A = index
  output << "A=D+A\n" #A = RAM[1] + index
  output << "D=M\n" #D = RAM[RAM[1] + index]
  output << push_from_D
  return output
end

def pop_local(index)
  output = "@1\n" #LCL = 1
  output << "D=M\n" #D = RAM[1]
  output << '@' << index << "\n" #A = index
  output << "D=D+A\n" #D = RAM[1] + index
  output << "@13\n" #temp register
  output << "M=D\n" #reg13 = RAM[1] + index
  output << pop_to_D #D = top of stack
  output << "@13\n"
  output << "A=M\n" #A = RAM[1] + index
  output << "M=D\n" #RAM[RAM[1] + index] = top of stack
  return output
end

def push_argument(index)
  output = "@2\n" #ARG = 2
  output << "D=M\n" #D = RAM[2]
  output << '@' << index << "\n" #A = index
  output << "A=D+A\n" #A = RAM[2] + index
  output << "D=M\n" #D = RAM[RAM[2] + index]
  output << push_from_D
  return output
end

def pop_argument(index)
  output = "@2\n" #ARG = 2
  output << "D=M\n" #D = RAM[2]
  output << '@' << index << "\n" #A = index
  output << "D=D+A\n" #D = RAM[2] + index
  output << "@13\n" #temp register
  output << "M=D\n" #reg13 = RAM[2] + index
  output << pop_to_D #D = top of stack
  output << "@13\n"
  output << "A=M\n" #A = RAM[2] + index
  output << "M=D\n" #RAM[RAM[2] + index] = top of stack
  return output
end

def push_this(index)
  output = "@3\n" #THIS = 3
  output << "D=M\n" #D = RAM[3]
  output << '@' << index << "\n" #A = index
  output << "A=D+A\n" #A = RAM[3] + index
  output << "D=M\n" #D = RAM[RAM[3] + index]
  output << push_from_D
  return output
end

def pop_this(index)
  output = "@3\n" #THIS = 3
  output << "D=M\n" #D = RAM[3]
  output << '@' << index << "\n" #A = index
  output << "D=D+A\n" #D = RAM[3] + index
  output << "@13\n" #temp register
  output << "M=D\n" #reg13 = RAM[3] + index
  output << pop_to_D #D = top of stack
  output << "@13\n"
  output << "A=M\n" #A = RAM[3] + index
  output << "M=D\n" #RAM[RAM[3] + index] = top of stack
  return output
end

def push_that(index)
  output = "@4\n" #THAT = 4
  output << "D=M\n" #D = RAM[4]
  output << '@' << index << "\n" #A = index
  output << "A=D+A\n" #A = RAM[4] + index
  output << "D=M\n" #D = RAM[RAM[4] + index]
  output << push_from_D
  return output
end

def pop_that(index)
  output = "@4\n" #THAT = 4
  output << "D=M\n" #D = RAM[4]
  output << '@' << index << "\n" #A = index
  output << "D=D+A\n" #D = RAM[4] + index
  output << "@13\n" #temp register
  output << "M=D\n" #reg13 = RAM[4] + index
  output << pop_to_D #D = top of stack
  output << "@13\n"
  output << "A=M\n" #A = RAM[4] + index
  output << "M=D\n" #RAM[RAM[4] + index] = top of stack
  return output
end

def push_temp(index)
  output = "@5\n" #const for temp
  output << "D=A\n" #D = 5
  output << '@' << index << "\n" #A = index
  output << "A=A+D\n" #A = index + 5
  output << "D=M\n" #D = RAM[index + 5]
  output << push_from_D
  return output
end

def pop_temp(index)
  output = "@5\n" #const for temp
  output << "D=A\n" #D = 5
  output << '@' << index << "\n" #A = index
  output << "D=A+D\n" #D = index + 5
  output << "@13\n"
  output << "M=D\n" #reg13 = index + 5
  output << pop_to_D #D = top of stack
  output << "@13\n"
  output << "A=M\n" #A = index + 5
  output << "M=D\n" #RAM[index + 5] = top of stack
  return output
end

def push_pointer(index)
  output = ''
  case index
    when '0'
      output << "@3\n" #THIS
    when '1'
      output << "@4\n" #THAT
  end
  output << "D=M\n" #D = RAM[THIS/THAT]
  output << push_from_D
  return output
end

def pop_pointer(index)
  output = pop_to_D #D = top of stack
  case index
    when '0'
      output << "@3\n" #THIS
    when '1'
      output << "@4\n" #THAT
  end
  output << "M=D\n" #RAM[THIS/THAT] = top of stack
end

def push_static(index, path)
  output = '@' << path.split('\\').last[0..-3] << index << "\n"
  output << "D=M\n"
  output << push_from_D
  return output
end

def pop_static(index, path)
  output = pop_to_D
  output << '@' << path.split('\\').last[0..-3] << index << "\n"
  output << "M=D\n"
  return output
end

def push_from_D
  output = "@SP\n"
  output << "A=M\n"
  output << "M=D\n"
  output << "D=A+1\n"
  output << "@SP\n"
  output << "M=D\n"
end

def translate_folder(folder_path)
  output = ''
  all_files = Dir.entries(folder_path)
  for file in all_files
    if file.end_with? '.vm'
      output << translate_file(folder_path + '\\' + file)
    end
  end
  out_file = folder_path + '\\' + 'output.asm'
  File.open(out_file, 'w') do |f|
   f.puts(output)
  end
end

translate_folder(ARGV[0])

