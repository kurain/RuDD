require 'RUBDD'
include  RUBDD
require 'pp'

class BtoI
  POWER30 = 1 << 30
  @@bout = ""
  @@P_OR = nil
  @@LitIP = 0
  @@IPList = []

  def self.ISOP0(s,r)
    puts 'ISOP0'
    return -1 if s == -1
    return -1 if r == -1
    return 0  if r == 1
    top = s.Top
    rtop = s.Top
    top = rtop if RUBDD.BDD_LevOfVar(top) < RUBDD.BDD_LevOfVar(rtop)

    if top == 0
      @@bout << '|' if @@P_OR != 0
      @@P_OR = 1
      for i in (0..@@LitIP)
        @@bout << "&" if i > 0
        var = @@IPList[i]
        @@bout << ' '
        if var >= 0
          @@bout << Symbol.var(var).to_s
        else
          @@bout << '!' + Symbol.var(-var).to_s
        end
      end
      return s
    end

    s0 = s.At0(top)
    r0 = r.At0(top)
    s1 = s.At1(top)
    r1 = r.At1(top)

    @@IPList[@@LitIP] = top
    @@LitIP += 1
    p1 = self.ISOP0(s1, r1 | s0)
    return p1 if p1 == -1

    @@IPList[@@LitIP-1] = -top
    p0 = self.ISOP0(s0, r0 | s1)
    return p0 if p0 == -1

    @@LitIP-=1
    sx = (s0 & s1)
    px = self.ISOP0(sx, ~sx|( (r0|p0) & (r1|p1) ))
    x = RUBDD.BDDvar(top)
    return (~x & p0) | (x & p1) | px
  end

  def self.ISOP(f)
    puts 'ISOP'
    return 1 if f == -1

    if f == 0
      @@bout << " 0"
    elsif f == 1
      @@bout << " 1"
    else
      @@IPList = Array.new(Symbol.vars.length)
      @@LitIP = 0
      @@P_OR = 0
      cov = self.ISOP0(f, ~f)
      @@IPList = nil
      return 1 if cov == -1
    end

    puts @@bout
    @@bout = ''
    return 0
  end

  def self.XISOP(f)
    puts 'XISOP'
    return 1 if f == -1

    if f == 0
      @@bout << ' 0'
      puts @@bout
      @@bout = ''
      return 0
    end

    if f == 1
      @@bout << '1'
      puts @@bout
      @@bout = ''
      return 0
    end

    paren = 0
    n_ip = Symbol.vars.length
    for i in (0..n_ip)
      var = i + RUBDD.BDDV_SysVarTop + 1
      f0 = f.At0(var)
      return 1 if f0 == -1
      next if f == f0
      fx = RUBDD.BDDvar(var) ^ f0
      return 1 if fx == -1
      next if f != fx
      @@bout << ' '

      if f0 == 0
        @@bout << Symbol.var(var)
        puts @@bout
        @@bout = ''
        return 0
      end

      if f0 == 1
        @@bout << '!' +  Symbol.var(var).to_s
        puts @@bout
        @@bout = ''
        return 0
      end
      @@bout << Symbol.var(var).to_s + ' ^'
      f = f0
      paren = 1
    end

    if paren != 0
      @@bout << ' '
      @@bout << '('
    end
    @@IPList = Array.new(n_ip)
    @@LitIP = 0
    @@P_OR = 0
    cov = self.ISOP0(f, ~f)
    @@IPList = []
    return 1 if cov == -1
    if paren != 0
      @@bout << ' )'
    end
    puts @@bout
    @@bout = ''
    return 0
  end

  def self.PutList(v, xor_, base)
    puts'PutList'
    return 1 if v.eq BtoI.new(BDD.new(-1))
    if base != 0 && v.Top == 0
      return 1 if self.PutNum(v, base)  == 1
      puts @@bout
      @@bout = ''
      return 0
    end

    sign = v.GetSignBDD
    err = nil

    if sign == 0
      if v.Len <= 2
        if xor_ == 0
          return self.ISOP(v.GetBDD(0))
        else
          return self.XISOP(v.GetBDD(0))
        end
      end
    else
      @@bout << "+-:"
      if xor_ == 0
        err = self.ISOP(v.GetBDD(0))
      else
        err = self.XISOP(v.GetBDD(0))
      end
      return 1 if err == 1
    end

    (v.Len - 2).downto(0){|i|
      @@bout << sprintf("%3d", i)
      if xor_ == 0
        err = self.ISOP(v.GetBDD(i))
      else
        err  = self.XISOP(v.GetBDD(i))
      end
      return 1 if err == 1
    }
    return 0
  end

  def self.PutNum(v, base)
    puts 'PutNum'
    ovf = 0

    if v.Top > 0
      v = v.UpperBound
      ovf = 1
    end

    alen = v.Len / 3 + 12
    err = nil
    s = Array.new(alen).pack("c*")

    if base == 16
      err = v.StrNum16(s)
    else
      err = v.StrNum10(s)
    end

    if err == 1
      s = nil
      return 1
    end

    len = s.length

    if ovf == 0
      for i in (0..5-len)
        @@bout << ' '
      end
      @@bout << ' ' + s
    else
      for i in (0..4-len)
        @@bout << ' '
      end
      @@bout << '(' + s + ')'
    end

    s = nil
    return 0
  end

  def print
    BtoI.PutList(self, 1, 10)
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
