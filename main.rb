require 'pry'
require 'timeout'

require_relative './lexer'
require_relative './parser'
require_relative './processor'

program = <<EOF
a = 3
b = 4
print a
print b
print a + b
c = a + b * 2 + a
d = a * b + 2 * a
print c
print d
EOF

$debug = false

tokens = Lexer.new(program).lex
puts tokens.map(&:to_s).join("\n") if $debug

node = Parser.new(tokens).parse
puts result.to_s if $debug

processor = Processor.new(node)
processor.process

puts "end variables:"
processor.variables.each do |name, value|
  puts "#{name} = #{value}"
end
