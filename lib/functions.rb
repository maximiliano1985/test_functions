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
    @functions = {
      :rosenbrock => { :f          => @@rosenbrock,
                       :class      => "nls",
                       :start      => [-1.2, 1],
                       :exax       => [1,1],
                       :exac_f_abs => 0.0
      },
      :freudenstein_and_roth => {
                       :f          => @@freudenstein_and_roth,
                       :class      => "nls",
                       :start      => [0.5, -2],
                       :exax_abs   => [5, 4],
                       :exac_f_abs => 0.0,
                       :exax_loc   => [11.41, -0.8968],
                       :exac_f_loc => 48.9842
      },
      :powell_badly_scaled => {
                       :f          => @@powell_badly_scaled,
                       :class      => "nls",
                       :start      => [0, 1],
                       :exax_abs   => [1.098e-5, 9.106],
                       :exac_f_abs => 0.0,
      },
      :brown_badly_scaled => {
                       :f          => @@brown_badly_scaled,
                       :class      => "nls",
                       :start      => [1, 1],
                       :exax_abs   => [1e6, 2e-6],
                       :exac_f_abs => 0.0,
      }
    }
    i = 0
    n_fcns = @functions.count if n_fcns == "all"
    fcns = {}
    @functions.each{|k,v| fcns[k]=v if i < n_fcns; i+=1}
    return fcns
  end
  
  
  def residual(fcns={})
    fcns.each_value{ |v| v[:residual] = (v[:f_now][i] - v[:exac_f_abs][i]) } # see the thopology of @functions hash
    return fcns
  end
  
=begin
  def increment(arg={})
    inc = 0.0
    arg[:x_now].each_index{ |i| inc += (arg[:x_now][i] - [:x_before][i]).abs }
    return inc
  end 
  def rosenbrock_m(x)
    raise "Dimension error" if x.size < 2
    f_1 = 10*(x[1] - x[0]**2)
    f_2 = 1 - x[0]
    return f_1**2 + f_2**2  
  end
=end
  @@rosenbrock = lambda do |x|
    raise "Dimension error" unless x.size == 2
    f = []
    f << 10*(x[1] - x[0]**2)
    f << 1 - x[0]
    return f.inject{ |v, n| v + n**2 }
  end
  
  @@freudenstein_and_roth = lambda do |x|
    raise "Dimension error" unless x.size == 2
    f = []
    f << -13 + x[0] + ( (5 - x[1])*x[1] - 2 )*x[1]
    f << -29 + x[0] + ( (x[1] + 1)*x[1] -14 )*x[1]
    return f.inject{ |v, n| v + n**2 }
  end
  
  @@powell_badly_scaled = lambda do |x|
    raise "Dimension error" unless x.size == 2
    f = []
    f << 10**4*x[0]*x[1] - 1
    f << Math::exp(-x[0]) + Math::exp(-x[1]) - 1.0001
    return f.inject{ |v, n| v + n**2 }
  end
  
  @@brown_badly_scaled = lambda do |x|
    raise "Dimension error" unless x.size == 2
    f = []
    f << x[0] - 1e6
    f << x[1] - 2e-6
    f << x[0]*x[1] - 2
    return f.inject{ |v, n| v + n**2 }
  end
end # module Functions





# References:
# [1] Hillstrom, K.E. A simulation test approach to the evaluation of nonlinear optimization algorithms. ACM Trans. Math. Softw. 3, 4 (1977), 305-315