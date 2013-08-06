require_relative 'helper'

describe LL do
  describe ".pass" do

    before do
      @out = StringIO.new
      @cb = LL.pass(->(*args) { @out.write("inside #{args}"); args }, [1, 2])
    end

    it "executes the provided proc" do
      @cb.()
      @out.string.should == 'inside [1, 2]'
    end

    it "initialises an array with provided arguments" do
      @cb.().should == [1, 2]
    end

    it "adds arguments to the existing array" do
      @cb.(3, 4).should == [1, 2, 3, 4]
    end

  end
end
