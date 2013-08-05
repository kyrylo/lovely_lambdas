require 'helper'

describe LL do
  describe ".create_sequence" do
    describe "provided original method only" do
      it "returns the argument back unchanged" do
        LL.create_sequence(:nothing).should == :nothing
      end
    end

    describe "provided original and new methods" do
      before do
        @out = StringIO.new
        first_drink = ->(drink) {
          @out.write("I drink #{drink} first. ")
          :sober
        }
        second_drink = ->(drink) {
          @out.write("After #{drink}, I usually prefer tequila!")
          :drunk
        }
        @drink_sequence = LL.create_sequence(first_drink, second_drink)
      end

      it "returns the value of the first proc" do
        @drink_sequence.('wine').should == :sober
      end

      it "executes the first proc and then the second one" do
        @drink_sequence.('wine')
        @out.string.should == 'I drink wine first. ' +
          'After wine, I usually prefer tequila!'
      end
    end

    describe "arguments of sequence's lambdas" do
      it "can be passed as many as you want" do
        out = StringIO.new
        l1 = ->(*args) { args.each{ |arg| out.write(arg) } }
        l2 = ->(*args) { out.write(' '); args.each{ |arg| out.write(arg) } }

        proc {
          sequence = LL.create_sequence(l1, l2)
          sequence.(1, 2, 3, 4, 5)
        }.should.not.raise

        out.string.should == '12345 12345'
      end
    end

  end
end
