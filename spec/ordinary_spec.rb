require 'ordinary'
include Ordinary

describe Ordinary do
  describe Ord do
    before :each do
      @two = Ord.new 2
      @four = Ord.new 4
      @six = Ord.new 6
    end

    it 'should provide an Ord class' do
      Ord.should be
    end

    context 'given a Fixnum' do
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
    end

    context 'with the first infinity' do
      it 'addition dwarfs any finite number' do
        (@two + Ord.Omega).should == Ord.Omega
      end

      it 'handles right addition differently' do
        (Ord.Omega + @two).should_not == Ord.Omega
      end

      it 'compares finite numbers' do
        (@two <=> @four).should == -1
        (@four <=> @two).should == 1
        (@four <=> @four).should == 0
      end

      it 'compares omega against finite numbers' do
        (@two <=> Ord.Omega).should == -1
        (Ord.Omega <=> @two).should == 1
        (Ord.Omega <=> Ord.Omega) == 0
      end

      it 'adds past omega' do
        (Ord.Omega + Ord.Omega).should > Ord.Omega
      end

      it 'adds past omega plus 1' do
        (Ord.Omega + Ord.Omega).should > (Ord.Omega + 1)
      end

      it 'adding omega to 1 does not count' do
        (1 + Ord.Omega).should == Ord.Omega
      end
      it 'adding one to omega counts' do
        (Ord.Omega + 1).should > Ord.Omega
      end

      it 'is associative' do
        (Ord.Omega + (Ord.Omega + 1)).should == ((Ord.Omega + Ord.Omega) + 1)
      end

      it 'accepts Float::Infinity' do
        (Ord.new Float::INFINITY).should == Ord.Omega
      end
    end
  end
end
