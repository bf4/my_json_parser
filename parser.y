# https://practicingruby.com/articles/parsing-json-the-hard-way
# https://gist.github.com/sandal/9532497/
# https://gist.githubusercontent.com/sandal/9532497/raw/8e3bb03fc24c8f6604f96516bf242e7e13d0f4eb/parser_example.y
# Defines a parser roughly equivalent to the regular expression
# pattern /(a|c)*abb/
#
# To try it out, run the following commands:
#
# $ gem install racc
# $ racc parser_example.y -o parser
# $ ruby parser abb 
# $ ruby parser acccaaaabb
# $ ruby parser zaaa
#
# The first two strings should parse correctly, the
# last one should result in an error being raised.

class Parser
rule
  string
    | a_or_cs abb
    | abb         
    ;
  a_or_cs
    : a_or_cs a_or_c
    | a_or_c
    ;
  a_or_c : 'a' | 'c' ;
  abb    : 'a' 'b' 'b' { puts "I found abb!" };
end

---- inner

require "strscan"

def next_token
  c = @ss.getch

  c ? [c, c] : nil
end

def parse(text)
  @ss = StringScanner.new(text)

  do_parse
end

---- footer
parser = Parser.new

# raises Racc::ParseError on failed match
parser.parse(ARGV[0]) 
