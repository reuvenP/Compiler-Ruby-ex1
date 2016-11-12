def translate(vm_path, asm_path)
  if !File.file?(vm_path)
    puts('VM File does not exists!')
    return
  end
  lines = IO.readlines(vm_path)
  output = ''
  for line in lines
    line = line.split
    if line[0] == '//'
        next
    end
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
  output = "\nTODO: implement add\n"
  return output
end

def sub
  output = "\nTODO: implement sub\n"
  return output
end

def neg
  output = "\nTODO: implement neg\n"
  return output
end

def eq
  output = "\nTODO: implement eq\n"
  return output
end

def gt
  output = "\nTODO: implement gt\n"
  return output
end

def lt
  output = "\nTODO: implement lt\n"
  return output
end

def f_and
  output = "\nTODO: implement f_and\n"
  return output
end

def f_or
  output = "\nTODO: implement f_or\n"
  return output
end

def f_not
  output = "\nTODO: implement f_not\n"
  return output
end

def push(segment, index)
  output = "\nTODO: implement push\n"
  output << 'segment: ' << segment
  output << ' index: ' << index
  output << "\n"
  return output
end

def pop(segment, index)
  output = "\nTODO: implement pop\n"
  output << 'segment: ' << segment
  output << ' index: ' << index
  output << "\n"
  return output
end
translate(ARGV[0], 'aaa')

