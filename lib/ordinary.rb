require "ordinary/version"

module Ordinary
  class Ord
    attr_reader :value

    def initialize(value)
      if value.is_a? Fixnum
        @value = [{coef: value, exp: 0}]
      elsif value == :omega
        @value = [{coef: 1, exp: 1}]
      elsif value.is_a? Array
        @value = value
      elsif value.is_a? Hash
        @value = [value]
      elsif value.is_a? Ord
        @value = value.value
      else
        raise ArgumentError
      end
    end

    def self.Omega
      Ord.new :omega
    end

    def +(other)
      if other == Ord.Omega
        return Ord.Omega
      end
      other = Ord.new other
      unmatched_theirs = other.value.clone
      unmatched_ours = @value.clone
      result = []
      @value.each do |term|
        matched = nil
        unmatched_theirs.delete_if do |t2|
          matched = t2 if term[:exp] == t2[:exp]
        end
        if matched
          unmatched_ours.delete term
          result.push({ coef: term[:coef] + matched[:coef], exp: term[:exp] })
        end
      end
      Ord.new(result.concat(unmatched_ours.concat unmatched_theirs))
    end

    def <=>(other)
      other = Ord.new other

      ours_sorted = @value.sort &term_compare(:desc)
      theirs_sorted = other.value.sort &term_compare(:desc)
      ours_sorted.each do |term|
        return 1 if theirs_sorted.empty?
        battle = term_compare.call term, theirs_sorted.first
        return battle if battle != 0
        theirs_sorted.pop
      end
      return 0
    end

    def ==(other)
      (self <=> other) == 0
    end

    private

    def term_compare direction=:asc
      Proc.new do |t, u|
        v = (2 * (t[:exp] <=> u[:exp])) + (t[:coef] <=> u[:coef])
        v /= (v != 0 ? v.abs : 1)
        (direction == :asc) ? v : -v
      end
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
