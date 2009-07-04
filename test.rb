require 'RUBDD'
include RUBDD
RUBDD.BDDV_Init(64,1000000)
f = []
10.times{|i|
  f << RUBDD.BDDvar(RUBDD.BDD_VarOfLev(i+1))
}
p RUBDD::BtoI.new(1).class
p RUBDD::BtoI.new(RUBDD.bdd_or(f[0],f[1]).Top).class
p f[0].class

