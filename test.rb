#!/usr/bin/env ruby
#  test
#
#  Created by Carlos Maximiliano Giorgio Bort on 2012-04-17.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#
require "./algorithms/optimizer_GA_NMM"

# Test function
f = lambda {|p| p[0]**2 + p[1]**2 -50} # a trivial parabola
#f = lambda { |p| p[0] ** 2 - 4 * p[0] + p[1] ** 2  -p[1] - p[0] * p[1]}
#f = lambda { |p| ( 1 - p[0] ) ** 2 + 100 * ( p[1] - p[0] ) ** 2 } # Rosenbroke function

# Instantiate the optimizer, with tolerance and dimension
opt = OP::Optimizer.new(
    :tol => 1,
    # 0.a) genetic algorithm optimizer configurations
    :ga_i_o         => { :X =>[5,10] , :Y=>[-10.23,5.234] }, # <<<--- YOU MUST SET THIS
    :ga_npop        => 5, 
    :ga_ncr         => 10,
    :ga_p_mutation  => 0.2,
    :ga_p_crossover => 0.8,
    :ga_tol         => 1e-4,
    
    # 0.b) nelder mead optimizer configurations
    :nm_niter       => 50, 
    :nm_exp_f       => 2.0,
    :nm_cnt_f       => 0.5,
    :nm_tol         => 1e-20
)

arr = [{}, {}]
# the output of the block must be an array with 2 elements,
# the first one is the variable (or an array with all the domain's variables)
# and the second one it's image.
opt.loop( arr ) { |p|  f.call(p) }
