require 'rdd'
n = 5
rules = []
n.times{|i|
  tmp = :"x#{i+1}1"
  (n-1).times{|j|
    tmp += :"x#{i+1}#{j+1}"
  }
  rules << (tmp == 1)
}
n.times{|i|
  tmp = :"x1#{i+1}"
  (n-1).times{|j|
    tmp += :"x#{j+1}#{i+1}"
  }
  rules << (tmp == 1)
}
