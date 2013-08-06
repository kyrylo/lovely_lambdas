module LL

  module_function

  # @overload pass(m, array)
  #   Wraps +m+ into a new Proc and prepopulates the underlying +array+.
  #
  #   @example
  #     p = LL.pass(->(*args){args}, [1])
  #     p.call #=> [1]
  #     p.call(2) #=> [1, 2]
  #     p.call #=> [1, 2]
  #
  #   @param [Proc] m the Proc to be wrapped; must accept at least 1 parameter
  #   @param [Array] array the Array, which holds the values to be immediately
  #     prepopulated
  #   @return [Proc] the new Proc, which allows adding new values to the
  #     prepopulated +array+
  # @overload pass(m, a, b)
  #   Wraps +m+ into a new Proc and add +a+, +b+, etc. to a new underlying array.
  #
  #   @example
  #     p = LL.pass(->(*args){args}, 1, 2)
  #     p.call #=> [1, 2]
  #     p.call(3) #=> [1, 2, 3]
  #     p.call #=> [1, 2, 3]
  #
  #   @param [Proc] m the Proc to be wrapped; must accept at least 1 parameter
  #   @param [Object] a the first value of the prepopulated array
  #   @param [Object] b the second value of the prepopulated array
  #   @return [Proc] the wrapped Proc, which allows adding new values to the
  #     prepopulated array
  def pass(m, *args)
    ar = args.flatten
    ->(*vals) {
      ar.push(*vals) unless vals.empty?
      m.(*ar)
    }
  end

end
