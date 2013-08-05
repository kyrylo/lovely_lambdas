require_relative 'helper'

describe LL do
  describe ".create_interceptor" do
    describe "provided original method only" do
      it "returns the argument back unchanged" do
        LL.create_interceptor(:nothing).should == :nothing
      end
    end

    describe "provided original and new methods" do
      before do
        @out = StringIO.new
        good_drink_msg = ->(drink) {
          @out.write("#{drink} is awesome!") }
        bad_drink_msg = ->(drink) {
          drink == 'kvas' ? true : (@out.write("#{drink} is bad!"); nil) }

        @interceptor = LL.create_interceptor(good_drink_msg, bad_drink_msg)
      end

      it "returns a lambda" do
        @interceptor.lambda?.should == true
      end

      it "executes the first lambda until the second one returns true" do
        @interceptor.('vodka')
        @out.string.should == 'vodka is bad!'
      end

      it "executes the second lambda" do
        @interceptor.('kvas')
        @out.string.should == 'kvas is awesome!'
      end
    end

    describe "return value" do
      it "returns nil by default" do
        interceptor = LL.create_interceptor(->a{}, ->a{})
        interceptor.('juice').should == nil
      end

      it "if there's the third argument, it is returned" do
        interceptor = LL.create_interceptor(->a{}, ->a{}, :tasty)
        interceptor.('juice').should == :tasty
      end

      it "comes from the original method after it's executed" do
        interceptor = LL.create_interceptor(->a{:icky}, ->a{true}, :tasty)
        interceptor.('juice').should == :icky
      end
    end

    describe "arguments of interceptor's lambdas" do
      it "can be passed as many as you want" do
        out = StringIO.new
        l1 = ->(one, two) { out.write('l1 executed') }
        l2 = ->(one, two) { one == two }

        proc {
          interceptor = LL.create_interceptor(l1, l2)
          interceptor.(10, 10)
        }.should.not.raise

        out.string.should == 'l1 executed'
      end
    end

  end
end
