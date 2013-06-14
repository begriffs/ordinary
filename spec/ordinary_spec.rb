require 'ordinary'
include Ordinary

describe Ordinary do
  describe Ord do
    it 'should provide an Ord class' do
      Ord.should be
    end

    context 'given a Fixnum' do
      before :each do
        @two = Ord.new 2
        @four = Ord.new 4
        @six = Ord.new 6
      end

      it 'returns an Ord after addition' do
        expect(@two + 2).to be_instance_of(Ord)
      end

      it 'can be added to Fixnums on the right' do
        (2 + @two).should be_instance_of(Ord)
      end

      it 'returns the correct value for Fixnum addition' do
        (2 + @two).should == @four
      end

      it 'compares against Fixnums' do
        @two.should == 2
      end

      it 'compares against Fixnums on the right' do
        2.should == @two
      end

      it 'handles multiplication' do
        (@two * 2).should == @four
        (@two * 3).should == @six
      end

      it 'refuses to subtract larger from smaller' do
        lambda { @two - @six }.should raise_error(ArgumentError)
      end

      it 'handles subtraction' do
        (@six - @two).should == @four
      end
    end
  end
end
