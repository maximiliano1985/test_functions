#!/usr/bin/env ruby
#  ga_my
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-03-06.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#
require './lib/tester'

NIT = 16000

tester = Tester.new(
  :n_fcns => "all",
  :res_file => "results.dat"
)

# procedure used to extract the solution from the array of iterations
extract_out = lambda do |a|
  [opt.simplex[:l][0], opt.simplex[:l][1], opt.iteration]
  # \__ X vector (solution)     \__ f(X) value    \__ number of iterations
end

# block used to adapt the function domain dinamically
# |domain| is an hash of arrays with as many elements as many is the dimension of the function domain.
# e.g. for a function: IR3 --> IR {:"1" => [-10, 10], :"2" => [-10, 10], :"3" => [-10, 10]}
tester.test( extract_out ) do |domain|
  raise "Hash needed" unless domain.class == Hash
  dim = domain.count
  opt = NMM::Optimizer.new(
    :dim   => dim + 1,
    :tol   => 1,
    :niter => NIT,
    :exp_f => 2,
    :cnt_f => 0.5,
    :pconv => false
  )
  
  start_points = []
  (dim+1).times do
    vec_ary = []
    domain.each_value{ |v| vec_ary << Random.new.rand( v[0].to_f .. v[1].to_f )  }
    start_points << Vector.elements( vec_ary, copy = true )
  end
  opt.start_points = start_points
end