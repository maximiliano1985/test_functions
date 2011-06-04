#!/usr/bin/env ruby
#  ga_my
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-03-06.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#
require './lib/tester'

tester = Tester.new :n_fcns => "all", :res_file => "results.dat"
# procedure used to extract the solution from the array of iterations
extract_out = lambda do |a|
  out_hash = a[(a.count-1).to_s.to_sym].first
  [out_hash[:chromosome], out_hash[:fitness], a.count*50]
end

# block used to adapt the function domain dinamically
tester.test( extract_out ) do |domain|
  raise "Hash needed" unless domain.class == Hash
  opt = GA::Optimizer.new( :tol => 1e-1,
  :p_mutation  => 0.2,
  :p_crossover => 0.8,
  :npop        => 100,
  :ncr         => 200,
  :pconv       => false,
  :i_o         => domain
  )
end