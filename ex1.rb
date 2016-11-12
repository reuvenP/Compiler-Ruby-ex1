def translate(vm_path, asm_path)
  if !File.file?(vm_path)
    puts('VM File does not exists!')
    return
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
          output << push(line[1], line[2])
        when 'pop'
          output << pop(line[1], line[2])
      end
  end
  puts(output)
end

def add
  output = "\n//add\n"
  return output
end

def sub
  output = "\n//sub\n"
  return output
end

def neg
  output = "\n//neg\n"
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
  return output
end

def f_or
  output = "\n//f_or\n"
  return output
end

def f_not
  output = "\n//f_not\n"
  return output
end

def push(segment, index)
  output = "\n//push"
  output << ' segment: ' << segment
  output << ' index: ' << index
  output << "\n"
  return output
end

def pop(segment, index)
  output = "\n//pop"
  output << ' segment: ' << segment
  output << ' index: ' << index
  output << "\n"
  return output
end
translate(ARGV[0], 'aaa')

