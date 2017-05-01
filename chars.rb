module Chars
  class << self
    def alpha? ch
      ('a' <= ch && ch <= 'z') ||
        ('A' <= ch && ch <= 'Z')
    end

    def num? ch
      ('0' <= ch && ch <= '9')
    end

    def alphanum? ch
      alpha?(ch) || num?(ch)
    end

    def operator? ch
      '+-*/^%='.include?(ch)
    end

    def eol? ch
      "\n\r".include?(ch)
    end

    def whitespace? ch
      %r{\s} =~ ch
    end
  end
end
