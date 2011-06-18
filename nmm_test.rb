#!/usr/bin/env ruby
#  ga_my
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-03-06.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#
require './lib/tester'

tester = Tester.new(
  :n_fcns   => "all",
  :res_file => "results_nmm.dat"#,
  #:plotopt  => {:title => "Modified Nelder Mead test: tollerance = 0.01, expansion factor = 2, contraction factor = 0.5"} 
)

# procedure used to extract the solution from the array of iterations
extract_out = lambda do |a|
  out = a.sorted.first
  [ out[1][0], out[1][1], a.iteration]
# X vector_/   \__ f(X) value   \__ number of iterations
end

# This block is used to adapt the function domain dinamically:
# |domain| is an hash of arrays with as many elements as many is the dimension of the function domain.
# e.g. for a function: IR3 --> IR {:"1" => [-10, 10], :"2" => [-10, 10], :"3" => [-10, 10]}
# extract_out is the procedure used to extract the solution X, f(X) and the number of iterations made
tester.test( extract_out ) do |domain|
  # define the starting simplex: is the analysed function is : IR^n --> IR, the starting simplex
  # must have "n+1" vertices, each with "n" coordinates
  @dim = domain.count + 1 # the dimension of the simplex
  opt = NMM::Optimizer.new(
    :dim   => @dim,
    :tol   => 1e-5,
    :niter => 2000,
    :exp_f => 2,
    :cnt_f => 0.5,
    :pconv => false
  )
  
  start_p = []
  @dim.times do |i|
    vec_ary = [domain[:"0"][0].to_f]*(@dim-1)
    vec_ary[i-1] = domain[:"0"][1].to_f unless i == 0
    p vec_ary
    start_p << Vector.elements( vec_ary, copy = true )
  end
  opt.start_points = start_p
  opt # returns the whole object "opt" 
end