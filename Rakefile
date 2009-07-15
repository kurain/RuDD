# -*- coding: utf-8 -*-
task "default" => "RUBDD.so"

file "RUBDD.so" => ["RUBDD_wrap.cxx","extconf.rb"] do
  sh "ruby extconf.rb"
  sh "make"
  rm "RUBDD.so"
  sh "g++ -shared -o RUBDD.so RUBDD_wrap.o BDD.a -L. -L/usr/lib -L../BDD-lnx/lib -lruby  -lpthread -ldl -lcrypt -lm -lc -lX11"
end

file "RUBDD_wrap.cxx" => "RUBDD.i" do
  cd '../BDD-lnx/include' do
    sh "swig -ruby -c++ RUBDD.i"
  end
end
