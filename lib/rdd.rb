require 'RUBDD'
require 'BtoI'
require 'bdd'

include RUBDD

def symbol *args
  args.each{|s|
    s.def_bdd
  }
end


class Symbol
  RUBDD.BDDV_Init(64,1000000)
  @@bdd_lev = 0
  @@var_symbol = {}
  attr_reader :btoi, :bdd
  def self.vars
    return @@var_symbol
  end

  def self.var(varid)
    @@var_symbol[varid]
  end

  def def_bdd
    @@bdd_lev += 1
    @bdd_var = RUBDD.BDD_NewVarOfLev(@@bdd_lev)
    @@var_symbol[@bdd_var] = self
    @bdd = RUBDD.BDDvar(@bdd_var)
    @btoi = BtoI.new(@bdd)
  end

  def bdd_check(other)
    other.def_bdd unless other.btoi
    self.def_bdd unless self.btoi
  end

  def +(other)
    bdd_check other
    new_btoi = self.btoi + other.btoi
  end

  def ^ (other)
    bdd_check other
    new_btoi = self.btoi ^ other.btoi
  end
end


