require "ordinary/version"

module Ordinary
  #class Infinity < Ord
  #end

  #def Infinity
  #  Ord.new specialvalue
  #end

  class Ord
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def +(other)
      if other.is_a? Ord
        other = other.value
      end
      Ord.new(@value + other)
    end

    def -(other)
      if other.is_a? Ord
        other = other.value
      end
      raise ArgumentError if other > @value
      Ord.new(@value - other)
    end

    def *(other)
      if other.is_a? Ord
        other = other.value
      end
      Ord.new(@value * other)
    end

    def ==(other)
      if other.respond_to? :value
        other = other.value
      end
      other == @value
    end
  end

  class ::Fixnum
    alias_method :old_add, :+
    alias_method :old_eql, :==

    def +(other)
      if other.is_a? Ord
        other + self
      else
        self.old_add other
      end
    end

    def ==(other)
      if other.is_a? Ord
        other == self
      else
        self.old_eql other
      end
    end
  end
end
