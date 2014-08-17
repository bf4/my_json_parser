# Our parser will send events to a document handler.
#
# The document handler will simply keep track of events sent to us by the parser.
# This creates tree-like data structure that we'll use to convert JSON to Ruby.
#
# Here's the events we're going to implement
#  start_object - called when an object is started
#  end_object - called when an object ends
#  start_array - called when an array is started
#  end_array - called when an array ends
#  scalar - called with terminal values like strings, true, false, etc
#
# @example if we parse {"foo":{"bar":null}}
# then the @stack variable will look like this:
#
# [[:root,
#   [:hash,
#     [:scalar, "foo"],
#     [:hash,
#       [:scalar, "bar"],
#       [:scalar, nil]]]]]
# @example if web parse ["foo",null,true]
# then the @stack variable will look like this:
#
# [[:root,
#   [:array,
#     [:scalar, "foo"],
#     [:scalar, nil],
#     [:scalar, true]]]]
module RJSON
  class Handler
    def initialize
      @stack = [[:root]]
    end

    # When the parser encounters the start of an object,
    #   the handler pushes a list on the stack with the "hash" symbol
    #   to indicate the start of a hash.
    # Events that are children will be added to the parent,
    #   then when the object end is encountered,
    #   the parent is popped off the stack.
    def start_object
      push [:hash]
    end

    def start_array
      push [:array]
    end

    def end_array
      @stack.pop
    end
    alias :end_object :end_array

    def scalar(s)
      @stack.last << [:scalar, s]
    end

    private

    def push(o)
      @stack.last << o
      @stack << o
    end
  end
end
# Now that we have an intermediate representation of the JSON,
# let's convert it to a Ruby data structure.
# To convert to a Ruby data structure,
# we can just write a recursive function to process the tree:
module RJSON
  class Handler
    # The result method removes the root node and sends the rest to the process method.
    def result
      root = @stack.first.last
      process root.first, root.drop(1)
    end

    private
    def process type, rest
      case type
      # an array is constructed recursively with the children.
      when :array
        rest.map { |x| process(x.first, x.drop(1)) }
      # builds a hash using the children by recursively calling process.
      when :hash
        Hash[rest.map { |x|
          process(x.first, x.drop(1))
        }.each_slice(2).to_a]
      # Scalar values are simply returned (which prevents an infinite loop).
      when :scalar
        rest.first
      end
    end
  end
end


