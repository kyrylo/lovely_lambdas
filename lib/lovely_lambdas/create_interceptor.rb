module LL

  module_function

  # Takes two Procs and wraps them in another one, composing everything into a
  # third one that is returned. All input is piped to the +newer+ Proc. The
  # +orig+ Proc is executed only if the +newer+ returns a positive value.
  #
  # @example
  #   original = proc { |arg| puts "[original] The #{arg} looks fine!" }
  #   newer = proc { |arg|
  #     puts "[newer] Hm, let me check that argument..."
  #     if arg == 42
  #       true
  #     else
  #       puts "[newer] No, it's not 42!"
  #     end
  #   }
  #
  #   interceptor = LL.create_interceptor(original, newer)
  #   interceptor.call(1)  #=> [newer] Hm, let me check that argument...
  #                        #   [newer] No, it's not 42!
  #
  #   interceptor.call(42) #=> [newer] Hm, let me check that argument...
  #                        #   [original] The 42 looks fine!
  # @param [Proc] orig the Proc to be executed when +newer+ returned a positive
  #   value
  # @param [Proc, nil] newer (nil) the Proc, which prevents/allows +orig+ to be
  #   executed
  # @param [Object] retval (nil) the return value for the +newer+ Proc
  # @return [Object, Proc] the wrapped Proc or an +orig+ if +newer+ is not
  #   specified
  def create_interceptor(orig, newer = nil, retval = nil)
    if (newer.nil?) || (!newer.is_a?(Proc) && !newer.lambda?)
      orig
    else
      ->(*args) {
        res = newer.(*args)
        res != false && res != nil ? orig.(*args) : retval
      }
    end
  end

end
