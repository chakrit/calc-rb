class Token
  attr_reader :type, :text
  attr_reader :line, :column

  def initialize(type, text, line=nil, column=nil)
    @type   = type
    @text   = text
    @line   = line
    @column = column
  end

  def location
    "line #{@line} column #{@column}"
  end

  def to_s
    if @line.nil?
      "token: #{text.inspect} #{type.inspect}"
    else
      "token: (#{@line}:#{@column}) #{text.inspect} #{type.inspect}"
    end
  end
end
