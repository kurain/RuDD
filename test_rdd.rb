$LOAD_PATH.push('lib')
require 'rdd'
r = []
5.times{|i|
  r[i] = (:"x#{i+1}1" + :"x#{i+1}2" + :"x#{i+1}3" + :"x#{i+1}4" + :"x#{i+1}5" ==1)
}
g = r[0] & r[1] & r[2] & r[3] & r[4]

c = []
5.times{|i|
  c[i] = (:"x1#{i+1}" + :"x2#{i+1}" + :"x3#{i+1}" + :"x4#{i+1}" + :"x5#{i+1}" == 1)
}

g = g & c[0] & c[1] & c[2] & c[3] & c[4]

d0 = (:x12 + :x21 < 2)
d1 = (:x13 + :x22 + :x31 < 2)
d2 = (:x14 + :x23 + :x32 + :x41 < 2)
d3 = (:x15 + :x24 + :x33 + :x42 + :x51 < 2)
d4 = (:x25 + :x34 + :x43 + :x52 < 2)
d5 = (:x35 + :x44 + :x53 < 2)
d6 = (:x45 + :x54 < 2)

g = g & d0 & d1 & d2 & d3 & d4 & d5 & d6

u0 = (:x14 + :x25 < 2)
u1 = (:x13 + :x24 + :x35 < 2)
u2 = (:x12 + :x23 + :x34 + :x45 < 2)
u3 = (:x11 + :x22 + :x33 + :x44 + :x55 < 2)
u4 = (:x21 + :x32 + :x43 + :x54 < 2)
u5 = (:x31 + :x42 + :x53 < 2)
u6 = (:x41 + :x52 < 2)

g = g & u0 & u1 & u2 & u3 & u4 & u5 & u6
p g.count
g.print

#4-queen
r = []
4.times{|i|
  r[i] = (:"x#{i+1}1" + :"x#{i+1}2" + :"x#{i+1}3" + :"x#{i+1}4" ==1)
}
g = r[0] & r[1] & r[2] & r[3]

c = []
4.times{|i|
  c[i] = (:"x1#{i+1}" + :"x2#{i+1}" + :"x3#{i+1}" + :"x4#{i+1}" == 1)
}

g = g & c[0] & c[1] & c[2] & c[3] 
d0 = (:x12 + :x21 < 2)
d1 = (:x13 + :x22 + :x31 < 2)
d2 = (:x14 + :x23 + :x32 + :x41 < 2)
d3 = (:x24 + :x33 + :x42 < 2)
d4 = (:x34 + :x43 < 2)

g = g & d0 & d1 & d2 & d3 & d4

u0 = (:x13 + :x24 < 2)
u1 = (:x12 + :x23 + :x34 < 2)
u2 = (:x11 + :x22 + :x33 + :x44 < 2)
u3 = (:x21 + :x32 + :x43 < 2)
u4 = (:x31 + :x42 < 2)

g = g & u0 & u1 & u2 & u3 & u4
p g.count
g.print



