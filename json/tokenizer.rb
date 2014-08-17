#  Our tokenizer is going to be constructed with an IO object.
#  Our tokenizer will return the following tokens, which we derived from the JSON spec:
#
#  Strings
#  Numbers
#  True
#  False
#  Null
#
#  'next_token' will read a token from the IO and return it
#
module RJSON
  class Tokenizer
    # These regular expressions were derived from the definitions on json.org.
    STRING = /"(?:[^"\\]|\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4}))*"/
    NUMBER = /-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/
    TRUE   = /true/
    FALSE  = /false/
    NULL   = /null/

    def initialize io
      # we could build an alternative tokenizer that reads from the IO as needed.
      @ss = StringScanner.new io.read
    end

    # Returns nil if there is nothing left to read from the string scanner,
    #   then it tries each regular expression until it finds a match.
    #   If it finds a match, it returns the name of the token (for example :STRING)
    #   along with the text that it matched. If none of the regular expressions match,
    #   then we read one character off the scanner, and return that character as
    #   both the name of the token, and the value.
    # @return [Array<String, Object>] first element: the name of the next token, 2nd element: its value
    # @return [nil] when there are no more tokens left
    # @example
    #   io_object = StringIO.new '{"foo":null}'
    #   tok = RJSON::Tokenizer.new(io_object)
    #   tok.next_token #=> ["{", "{"]
    #   tok.next_token #=> [:STRING, "\"foo\""]
    #   tok.next_token #=> [":", ":"]
    #   tok.next_token #=> [:NULL, "null"]
    #   tok.next_token #=> ["}", "}"]
    #   tok.next_token #=> nil
    def next_token
      return if @ss.eos?

      case
      when text = @ss.scan(STRING) then [:STRING, text]
      when text = @ss.scan(NUMBER) then [:NUMBER, text]
      when text = @ss.scan(TRUE)   then [:TRUE, text]
      when text = @ss.scan(FALSE)  then [:FALSE, text]
      when text = @ss.scan(NULL)   then [:NULL, text]
      else
        x = @ss.getch
        [x, x]
      end
    end
  end
end
