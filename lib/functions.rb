#!/usr/bin/env ruby
#  functions
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-03-06.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#
=begin
As Hillstrom [1] proposed, here the starting points used in the optimizations are chosen from a box surrounding the standard starting point.
One can evaluate the performances of the agorithm by counting the number of iterations required to converge to the solution.
For each test function is defined a procedure, its name, its type and its starting points. The functions are defined in alphabetical order.
=end

module Functions
  
  def load_fcns( n_fcns = "all" ) # list of all the test functions
    @nonlinear_last_squares = {
      :rosenbrock => @@rosenbrock,
      :casa => ''
    }
    #puts "---> #{@@rosenbrock.call([1,2])}"
    i = 0
    n_fcns = @nonlinear_last_squares.count if n_fcns == "all"
    fcns = {}
    @nonlinear_last_squares.each{|k,v| fcns[k]=v if i < n_fcns; i+=1}
    return fcns
  end
  
  def unconstrained_minimisation(x, &block)
  end
  
  def systems_of_nonlinear_equations(x, &block)
  end
  
  def residual(arg={})
    res = 0.0
    arg[:f_now].each_index{ |i| res += (arg[:f_now][i] - arg[:f_min][i]).abs }
    return res
  end

  def increment(arg={})
    inc = 0.0
    arg[:x_now].each_index{ |i| inc += (arg[:x_now][i] - [:x_before][i]).abs }
    return inc
  end
=begin  
  def rosenbrock_m(x)
    raise "Dimension error" if x.size < 2
    f_1 = 10*(x[1] - x[0]**2)
    f_2 = 1 - x[0]
    return f_1**2 + f_2**2  
  end
=end
  @@rosenbrock = lambda do |x|
    raise "Dimension error" if x.size < 2
    f_1 = 10*(x[1] - x[0]**2)
    f_2 = 1 - x[0]
    return f_1**2 + f_2**2
  end
  
end # module Functions





# References:
# [1] Hillstrom, K.E. A simulation test approach to the evaluation of nonlinear optimization algorithms. ACM Trans. Math. Softw. 3, 4 (1977), 305-315