# https://practicingruby.com/articles/parsing-json-the-hard-way
# Given a pattern we want to match: (a|c)*abb
class Parser
rule
  # a_or_c is called a 'production'. a_or_c is what we are naming the production
  # that is equivalent to the regex /a|c/
  a_or_c : 'a' | 'c' ;
end

class Parser
rule
  # adding a recursive production like /(a|c)+/
  # i.e. recurse this a_or_c if followed by an a_or_c
  #   otherwise, just match the one a_or_c
  a_or_cs
    : a_or_cs a_or_c
    | a_or_c
    ;
  a_or_c : 'a' | 'c' ;
end

class Parser
rule
  a_or_cs
    : a_or_cs a_or_c
    | a_or_c
    ;
  a_or_c : 'a' | 'c' ;
  # adding the abb production
  abb    : 'a' 'b' 'b';
end

class Parser
rule
  # final production:
  # matches any number of a_or_cs followed by abb
  # or just abb
  string
    : a_or_cs abb
    | abb
    ;
  a_or_cs
    : a_or_cs a_or_c
    | a_or_c
    ;
  a_or_c : 'a' | 'c' ;
  abb    : 'a' 'b' 'b';
end

class Parser
rule
  string
    : a_or_cs abb
    | abb
    ;
  a_or_cs
    : a_or_cs a_or_c
    | a_or_c
    ;
  a_or_c : 'a' | 'c' ;
  # We can run arbitrary Ruby code on a match.
  # after the rule, we wrap it in curly braces
  abb    : 'a' 'b' 'b'; { puts "I found abb!" };
end

# oh, don't forget to add a tokenizer to break the data into tokens
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

# and don't forget the boilerplate code
---- footer
parser = Parser.new

# raises Racc::ParseError on failed match
parser.parse(ARGV[0]) 
