# @example
# require 'rjson'
#
# input   = StringIO.new '{"foo":"bar"}'
# tok     = RJSON::Tokenizer.new input
# parser  = RJSON::Parser.new tok
# handler = parser.parse
# handler.result # => {"foo"=>"bar"}
