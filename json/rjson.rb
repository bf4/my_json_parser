# @example
# require 'rjson'
#
# RJSON.load(input) # => {"foo"=>"bar"}
module RJSON
  def self.load(json)
    input   = StringIO.new json
    tok     = RJSON::Tokenizer.new input
    parser  = RJSON::Parser.new tok
    handler = parser.parse
    handler.result
  end
end
