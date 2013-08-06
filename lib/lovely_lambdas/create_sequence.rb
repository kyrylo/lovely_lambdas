module LL

  module_function

  # @overload create_sequence(orig, newer)
  #   Consequently executes +orig+ and +newer+ respectively. The return value is
  #   a new Proc, whose return value is the return value of +orig+.
  #
  #   @example
  #     first = ->(noun) { puts "Have you passed through this #{noun}?"; 'yes' }
  #     second = ->(noun) { puts "The #{noun} is beautiful, isn't it?" }
  #     sequence = LL.create_sequence(first, second)
  #     have_you = sequence.call('night') #=> Have you passed through this night?
  #                                       #   The night is beautiful, isn't it?
  #     puts have_you #=> yes
  #   @param [Proc] orig the first proc to be executed
  #   @param [Proc] newer (nil) the second proc to be executed
  #   @return [Proc] the wrapped Proc
  #
  # @overload create_sequence(orig)
  #   @param [Object] orig
  #   @return [Object] +orig+
  def create_sequence(orig, newer = nil)
    if newer.nil?
      orig
    else
      ->(*args) {
        orig_retval = orig.(*args)
        newer.(*args)
        orig_retval
      }
    end
  end

end
