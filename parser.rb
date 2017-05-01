require_relative './nodes'

class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  def parse
    parse_block
  end

  def parse_block
    nodes = []
    nodes << parse_statement until eof?
    Nodes::Block.new(nodes)
  end

  def parse_statement
    puts "statement" if $debug
    id = peek
    error "expected identifier at #{id.location}" unless id.type == :identifier
    case
    when id.text == "print"
      parse_print
    else
      parse_assignment
    end
  end

  def parse_print
    puts "print" if $debug
    id = consume
    error "expected `print` keyword" unless id.type == :identifier && id.text == "print"
    expr, eol = parse_expression, consume
    error "expected EOL" unless eol.type == :eol
    Nodes::Print.new(expr)
  end

  def parse_assignment
    puts "assignment" if $debug
    id = parse_reference
    op = consume
    error "expected `=` operator" unless op.type == :operator && op.text == '='
    expr, eol = parse_expression, consume
    error "expected EOL" unless eol.type == :eol
    Nodes::Assign.new(id, expr)
  end

  def parse_expression
    puts "expression" if $debug
    parse_sum
  end

  def parse_sum
    puts "sum" if $debug
    lhs, op = parse_product, peek
    case
    when op.nil? || op.type == :eol
      lhs
    when op.type != :operator
      error "expected operator"
    when op.text == "+"
      consume
      Nodes::Sum.new(lhs, parse_sum)
    else # op has lower precendence, return to upper level
      lhs
    end
  end

  def parse_product
    puts "product" if $debug
    lhs, op = parse_value_or_reference, peek
    case
    when op.nil? || op.type == :eol
      lhs
    when op.type != :operator
      error "expected operator"
    when op.text == "*"
      consume
      Nodes::Product.new(lhs, parse_product)
    else # op has lower precendence, return to upper level
      lhs
    end
  end

  def parse_value_or_reference
    puts "value_or_reference" if $debug
    token = peek
    case
    when token.type == :value
      parse_value
    when token.type == :identifier
      parse_reference
    else
      error "expected identifier or value"
    end
  end

  def parse_value
    puts "value" if $debug
    Nodes::Value.new(consume.text.to_i)
  end

  def parse_reference
    puts "reference" if $debug
    Nodes::Reference.new(consume.text)
  end

  private

  def error msg
    raise msg
  end

  def eof?
    @tokens.length == 0
  end

  def eol?
    peek.type == :eol
  end

  def peek(n=1)
    @tokens[n-1]
  end

  def consume
    token, @tokens = @tokens[0], @tokens[1..-1]
    puts "consume: #{token.text.inspect}" if $debug
    token
  end
end
