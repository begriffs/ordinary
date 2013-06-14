require "ordinary/version"

module Ordinary
  class Ord
    attr_reader :value

    def initialize value
      if value.is_a? Fixnum
        @value = [{coef: value, exp: 0}]
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
      Ord.new [{coef: 1, exp: 1}]
    end

    def + other
      other = Ord.new other
      if other >> self
        return other
      end
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

    def <=> other
      other = Ord.new other

      ours_sorted = @value.sort &term_compare(:desc)
      theirs_sorted = other.value.sort &term_compare(:desc)
      ours_sorted.each do |term|
        return 1 if theirs_sorted.empty?
        battle = term_compare.call term, theirs_sorted.shift
        return battle if battle != 0
      end
      return 0
    end

    # way less
    def << other
      highest_term[:exp] < other.highest_term[:exp]
    end

    # way more
    def >> other
      highest_term[:exp] > other.highest_term[:exp]
    end

    def == other
      (self <=> other) == 0
    end

    def > other
      (self <=> other) == 1
    end

    def >= other
      [1, 0].include? (self <=> other)
    end

    def < other
      (self <=> other) == -1
    end

    def <= other
      [-1, 0].include? (self <=> other)
    end

    def highest_term
      @value.max_by { |x| x[:exp] }
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
        Ord.new(self) + other
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
