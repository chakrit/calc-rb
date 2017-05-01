require_relative './nodes'

class Processor
  attr_reader :variables

  def initialize(root)
    @root      = root
    @variables = {}
  end

  def process
    process_root(@root)
  end

  protected

  def process_root(node)
    case
    when node.is_a?(Nodes::Block)
      process_block(node)
    when node.is_a?(Nodes::Assign)
      process_assignment(node)
    when node.is_a?(Nodes::Print)
      process_print(node)
    else
      error "unsupported node: #{node}"
    end
  end

  def process_block(block)
    block.nodes.each do |node|
      process_root(node)
    end
  end

  def process_assignment(assignment)
    lhs, rhs = assignment.lhs, assignment.rhs
    error "cannot assign to non-variable" unless lhs.is_a?(Nodes::Reference)
    @variables[lhs.name] = resolve_expression(rhs)
  end

  def process_print(print)
    result = resolve_expression(print.expression)
    puts "OUTPUT: #{result}"
  end

  def resolve_expression(expression)
    case
    when expression.is_a?(Nodes::Sum)
      resolve_sum(expression)
    when expression.is_a?(Nodes::Product)
      resolve_product(expression)
    when expression.is_a?(Nodes::Value)
      resolve_value(expression)
    when expression.is_a?(Nodes::Reference)
      resolve_reference(expression)
    else
      error "unsupported expression: #{expression}"
    end
  end

  def resolve_sum(sum)
    resolve_expression(sum.lhs) + resolve_expression(sum.rhs)
  end

  def resolve_product(product)
    resolve_expression(product.lhs) * resolve_expression(product.rhs)
  end

  def resolve_reference(reference)
    @variables[reference.name]
  end

  def resolve_value(value)
    value.value
  end

  private

  def error msg
    raise msg
  end
end
