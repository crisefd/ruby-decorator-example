module Validator
  class ValidationError < ArgumentError; end
    refine Module do
      def validate(*methods, &validator)
        prepend(Module.new do
          methods.each do |method|
            define_method(method) do |*args, &blk|
              raise ValidationError, args.inspect unless yield *args
              super(*args, &blk)
            end
          end
        end)
      end
    end
end

class Foo
  using Validator

  def foo(a, b, c)
    p a, b, c
  end

  def bar(a, b)
    p a, b
  end

  validate(:foo, :bar) {|*args, &blk| args.reduce(:+) == 6 }
end
