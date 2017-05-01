module Nodes
  class Node
    def to_s(indent=0)
      "ast: #{self.class.name} #{self.inspect}"
    end
  end

  class Block < Node
    attr_reader :nodes

    def initialize(nodes)
      @nodes = nodes
    end

    def to_s(indent=0)
      "#{"  " * indent}block:\n" +
        @nodes.map { |node| node.to_s(indent+1) }.join("")
    end
  end

  class Print < Node
    attr_reader :expression

    def initialize(expr)
      @expression = expr
    end

    def to_s(indent=0)
      "#{"  " * indent}print:\n" +
        @expression.to_s(indent+1)
    end
  end

  class Assign < Node
    attr_reader :lhs, :rhs

    def initialize(lhs, rhs)
      @lhs, @rhs = lhs, rhs
    end

    def to_s(indent=0)
      "#{"  " * indent}assign:\n" +
        @lhs&.to_s(indent+1) +
        @rhs&.to_s(indent+1)
    end
  end

  class Expression < Node
  end

  class Product < Expression
    attr_reader :lhs, :rhs

    def initialize(lhs, rhs)
      @lhs, @rhs = lhs, rhs
    end

    def to_s(indent=0)
      "#{"  " * indent}product:\n" +
        @lhs&.to_s(indent+1) +
        @rhs&.to_s(indent+1)
    end
  end

  class Sum < Expression
    attr_reader :lhs, :rhs

    def initialize(lhs, rhs)
      @lhs, @rhs = lhs, rhs
    end

    def to_s(indent=0)
      "#{"  " * indent}sum:\n" +
        @lhs&.to_s(indent+1) +
        @rhs&.to_s(indent+1)
    end
  end

  class Value < Expression
    attr_reader :value

    def initialize(value)
      @value = value.to_i
    end

    def to_s(indent=0)
      "#{"  " * indent}value: #{@value}\n"
    end
  end

  class Reference < Expression
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def to_s(indent=0)
      "#{"  " * indent}reference: #{@name}\n"
    end
  end
end
