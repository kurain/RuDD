require 'RUBDD'
include RUBDD
def symbol *args
  args.each{|s|
    s.def_bdd
  }
end
class BDD
  def bdd_check other
    return other if other.class == BDD
    return BDD.new(other) if other.class == Fixnum
  end

  def |(other)
    other = bdd_check other
    RUBDD.bdd_bar(self,other)
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

class BtoI
  POWER30 = 1 << 30
  @@bout = ""
  @@P_OR = nil
  @@LitIP = nil
  @@IPList = []
  def self.ISOP0(s,r)
    return -1 if s == -1
    return -1 if r == -1
    return 0  if r == 1
    top = s.Top
    rtop = s.Top
    top = rtop if RUBDD.BDD_LevOfVar(top) < RUBDD.BDD_LevOfVar(rtop)

    if top == 0
      @@bout << "|" if @@P_OR != 0
      @@P_OR = 1
      @@LitIP.times{|i|
        @@bout << "&" if i > 0
        var = IPList[i]
        @@bout << " "
        if var >= 0
          @@bout << Symbol.var(var)
        else
          @@bout << "!"
          @@bout << Symbol.var(-var)
        end
      }
      return s
      s0 = s.At0(top)
      r0 = r.At0(top)
      s1 = s.At1(top)
      r1 = r.At1(top)
      @@IPList[@@LitIP+=1] = top
      p1 = self.ISOP0(s1, r1 | s0)
      return p1 if p1 == -1

      @@IPList[@@LitIP-1] = top
      p0 = self.ISOP0(s0, r0 | s1)
      return p0 if p0 == -1

      @@LitIP-=1
      sx = (s0 & s1)
      px = self.ISOP0(sx, ~sx|((r0|p0) & (r1|p1)))
      x = RUBDD.BDDVar(top)
      return (~x & p0) | (x & p1) | px
    end
  end
  def count(bdd=self.ne(0).GetBDD(0))
    return 0 if bdd == -1
    return 0 if bdd == 0
    var = bdd.Top
    if bdd == 1
      c = 1
    else
      c = RUBDD.BDD_CacheInt(22, bdd.GetID, 0)
      if c > POWER30
        c = count(bdd.At0(var)) + count(bdd.At1(var))
        RUBDD.BDD_CacheEnt(22, bdd.GetID, 0, c)
      end
    end
    return c
  end

  def btoi_check other
    return other if other.class == BtoI
    if other.class == Symbol
      if other.btoi
        return other.btoi
      else
        other.def_bdd
        return other.btoi
      end
    end
    return BtoI.new(other) if other.class == Fixnum
  end
  def == (other)
    other = btoi_check other
    RUBDD.BtoI_EQ(self,other)
  end

  def eq (other)
    other = btoi_check other
    if RUBDD.btoi_eq(self,other) == 1
      return true
    else
      return false
    end
  end

  def ne (other)
    other = btoi_check other
    RUBDD.BtoI_NE(self,other)
  end
  def < (other)
    other = btoi_check other
    RUBDD.BtoI_LT(self,other)
  end

  def > (other)
    other = btoi_check other
    RUBDD.BtoI_GT(self,other)
  end

  def ^ (other)
    other = btoi_check other
    RUBDD.btoi_hat(self,other)
  end
  def + (other)
    other = btoi_check other
    RUBDD.btoi_add(self,other)
  end
  def & (other)
    other = btoi_check other
    RUBDD.btoi_and(self,other)
  end
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


