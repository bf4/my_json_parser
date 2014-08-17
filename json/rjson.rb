# @example
# require 'rjson'
# require 'open-uri'
# RJSON.load '{"foo":"bar"}' # => {"foo"=>"bar"}
# RJSON.load_io open('http://example.org/some_endpoint.json')
module RJSON
  # allow passing a socket or file handle
  def self.load_io(input)
    tok     = RJSON::Tokenizer.new input
    parser  = RJSON::Parser.new tok
    handler = parser.parse
    handler.result
  end
  def self.load(json)
    load_io StringIO.new json
  end
end
