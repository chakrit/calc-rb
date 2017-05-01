require_relative './chars'
require_relative './token'

class Lexer
  def initialize(buffer)
    @buffer = buffer
    @line   = 0
    @column = 0
  end

  def lex
    @line, @column = 1, 0
    lex_start
  end

  protected

  def lex_start
    tokens = []
    until eof?
      ch = peek
      case
      when Chars.alpha?(ch)
        tokens += lex_identifier
      when Chars.num?(ch)
        tokens += lex_value
      when Chars.operator?(ch)
        tokens += lex_operator
      when Chars.eol?(ch)
        tokens += lex_eol
      when Chars.whitespace?(ch)
        tokens += lex_whitespace
      end
    end

    tokens
  end

  def lex_identifier
    text = ''
    text += consume while !eof? && Chars.alphanum?(peek)
    [token(:identifier, text)]
  end

  def lex_eol
    text = ''
    text += consume while !eof? && Chars.eol?(peek)
    [token(:eol, text)]
  end

  def lex_whitespace
    consume while !eof? && Chars.whitespace?(peek)
    [] # whitespace ignored
  end

  def lex_operator
    [token(:operator, consume)]
  end

  def lex_value
    text = ''
    text += consume while !eof? && Chars.num?(peek)
    [token(:value, text)]
  end

  private

  def eof?
    @buffer.length == 0
  end

  def token(type, text)
    Token.new(type, text, @line, @column)
  end

  def peek
    @buffer[0]
  end

  def consume
    ch, @buffer = @buffer[0], @buffer[1..-1]
    if Chars.eol?(ch)
      @line += 1
      @column = 0
    else
      @column += 1
    end

    ch
  end
end
