#!/usr/bin/env ruby
#  ga_my
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-03-06.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#
require './lib/tester'

NPOP = 200
NCR = 150

tester = Tester.new :n_fcns => "all", :res_file => "results.dat"
# procedure used to extract the solution from the array of iterations
extract_out = lambda do |a|
  out = a[0]
  #out_hash = a[(a.count-1).to_s.to_sym].first
  [out[:chromosome], out[:fitness], a.count*NPOP]
  # \__ X vector (solution)  \__ f(X) value  \__ number of iterations
end

# block used to adapt the function domain dinamically
# |domain| is an hash of arrays with as many elements as many is the dimension of the function domain.
# e.g. for a function: IR3 --> IR {:"1" => [-10, 10], :"2" => [-10, 10], :"3" => [-10, 10]}
tester.test( extract_out ) do |domain|
  raise "Hash needed" unless domain.class == Hash
  opt = GA::Optimizer.new(
  :tol => 1,
  :p_mutation  => 0.2,
  :p_crossover => 0.8,
  :npop        => NPOP,
  :ncr         => NCR,
  :pconv       => false,
  :i_o         => domain
  )
end