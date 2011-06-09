#!/usr/bin/env ruby
#  ga_my
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-03-06.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#
require './lib/tester'

NIT = 100 # 16000

tester = Tester.new(
  :n_fcns => "all",
  :res_file => "results.dat"
)

# procedure used to extract the solution from the array of iterations
extract_out = lambda do |a|
  out = a.first
  [ out[1][0], out[1][1], a.count]
# X vector_/   \__ f(X) value   \__ number of iterations
end

# This block is used to adapt the function domain dinamically:
# |domain| is an hash of arrays with as many elements as many is the dimension of the function domain.
# e.g. for a function: IR3 --> IR {:"1" => [-10, 10], :"2" => [-10, 10], :"3" => [-10, 10]}
# extract_out is the procedure used to extract the solution X, f(X) and the number of iterations made
tester.test( extract_out ) do |domain|
  @dim = domain.first[1].count
  opt = NMM::Optimizer.new(
    :dim   => @dim + 1,
    :tol   => 1,
    :niter => NIT,
    :exp_f => 2,
    :cnt_f => 0.5,
    :pconv => false
  )
  
  start_p = []
  domain.each_value do |v|
    vec_ary = []
    @dim.times{ vec_ary << Random.new.rand( v[0].to_f .. v[1].to_f )  }
    start_p << Vector.elements( vec_ary, copy = true )
  end
  puts "*"*4+"#{domain}"
  puts "*"*4+"#{start_p}"
  opt.start_points = start_p
  opt # returns the whole object "opt" 
end