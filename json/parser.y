# We're going to translate the diagrams from json.org to a Racc grammar.
# we let Racc know about our special tokens by declaring them at the top
class RJSON::Parser
token STRING NUMBER TRUE FALSE NULL
# JSON document should be an object or an array at the root,
# so we'll make a production called document and it should be an object or an array:
rule
  document
    : object
    | array
    ;
  # The array production can either be empty, or contain 1 or more values:
  array
    : '[' ']'
    | '[' values ']'
    ;
  # The values production can be recursively defined as one value,
  # or many values separated by a comma:
  values
    : values ',' value
    | value
    ;
  # The JSON spec defines a value as a string, number, object, array, true, false, or null.
  # for the immediate values such as NUMBER, TRUE, and FALSE,
  # we'll use the token names we defined in the tokenizer:
  value
    : string
    | NUMBER
    | object
    | array
    | TRUE
    | FALSE
    | NULL
    ;
  # Objects can be empty, or have many pairs:
  object
    : '{' '}'
    | '{' pairs '}'
    ;
  # pairs must be separated with a comma. 
  # We can define them recursively
  pairs
    : pairs ',' pair
    | pair
    ;
  # a pair is a string and value separated by a colon:
  pair
    : string ':' value
    ;
  string : STRING ;
end
