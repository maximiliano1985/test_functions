#!/usr/bin/env ruby
#  ga_my
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-03-06.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#
require './lib/tester'
require "./algorithms/optimizer_GA_NMM"

NIT = 16000

tester = Tester.new(
  :n_fcns   => "all",
  :res_file => "results_ga_nmm.dat"#,
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
  # Instantiate the optimizer, with tolerance and dimension
  opt = OP::Optimizer.new(
    :tol => 1e-2,
    # a) genetic algorithm optimizer configurations
    :ga_i_o         => domain,
    :ga_npop        => 10, 
    :ga_ncr         => 100,
    :ga_p_mutation  => 0.2,
    :ga_p_crossover => 0.8,
    :ga_tol         => 1e-4,
    :ga_pconv       => false,
    
    # b) nelder mead optimizer configurations
    :nm_niter       => 2000, 
    :nm_exp_f       => 2.0,
    :nm_cnt_f       => 0.5,
    :nm_tol         => 1e-5,
    :nm_pconv       => false
  )
  opt # returns the whole object "opt" 
end