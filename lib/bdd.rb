require 'RUBDD'
include RUBDD

class BDD
  def bdd_check other
    return other if other.class == BDD
    return BDD.new(other) if other.class == Fixnum
  end

  def |(other)
    other = bdd_check other
    RUBDD.bdd_or(self,other)
  end

  def &(other)
    other = bdd_check other
    RUBDD.bdd_and(self,other)
  end

  def ^(other)
    other = bdd_check other
    RUBDD.bdd_hat(self,other)
  end

  def ==(other)
    other = bdd_check other
    if RUBDD.bdd_eq(self,other) == 1
      return true
    else
      return false
    end
  end
end
