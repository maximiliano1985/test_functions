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

INF = 1.0/0.0

module Functions
  
  def load_fcns( n_fcns = "all" ) # list of all the test functions
    @functions = {
      :rosenbrock => { :f     => @@rosenbrock,
                       :class => "sne-nls",
                       :start => [-1.2, 1], # first trial point
                       :x_abs => [1,1],     # absolute minimum abscissae
                       :f_abs => 0.0        # absolute minimum ordinate
      },
      :freudenstein_and_roth => {
                       :f     => @@freudenstein_and_roth,
                       :class => "nls",
                       :start => [0.5, -2],
                       :x_abs => [5, 4],
                       :f_abs => 0.0,
                       :x_loc => [11.41, -0.8968],
                       :f_loc => 48.9842
      },
      :powell_badly_scaled => {
                       :f     => @@powell_badly_scaled,
                       :class => "sne-umi",
                       :start => [0, 1],
                       :x_abs => [1.098e-5, 9.106],
                       :f_abs => 0.0
      },
      :brown_badly_scaled => {
                       :f     => @@brown_badly_scaled,
                       :class => "umi",
                       :start => [1, 1],
                       :x_abs => [1e6, 2e-6],
                       :f_abs => 0.0
      },
      :beale => {
                       :f     => @@beale,
                       :class => "umi",
                       :start => [1,1],
                       :x_abs => [3, 0.5],
                       :f_abs => 0.0
      },
      :jennrich_and_sampson => {
                       :f     => @@jennrich_and_sampson,
                       :class => "nls",
                       :start => [0.3,0.4],
                       :x_abs => [0.2578, 0.2578],
                       :f_abs => 124.362
      },
      :helical_valley => {
                       :f     => @@helical_valley,
                       :class => "sne-nls",
                       :start => [-1,0,0],
                       :x_abs => [ 1,0,0],
                       :f_abs => 0.0
      },
      :bard => {
                       :f     => @@bard,
                       :class => "nls",
                       :start => [1,1,1],
                       :x_abs => [0.8406,-INF, -INF],
                       :f_abs => 17.4286 ############## ambiguities here
      },
      :gaussian => {
                       :f     => @@gaussian,
                       :class => "umi",
                       :start => [0.4, 1, 0],
                       :x_abs => [0,0,0],############## ambiguities here
                       :f_abs => 1.12793e-8
      }
    }
    i = 0
    n_fcns = @functions.count if n_fcns == "all" || n_fcns >= @functions.count
    fcns = {}
    @functions.each{|k,v| fcns[k]=v if i < n_fcns; i+=1}
    return fcns
  end
  
  
  def residual(fcns={})
    fcns[:residual] = fcns[:f_cal] - fcns[:f_abs]
    return fcns
  end
  
  def res_err_perc(fcns={})
    fcns[:res_err_perc] = (100*(fcns[:f_cal] - fcns[:f_abs])/fcns[:f_abs]).abs
    return fcns
  end
  
  def increment(fcns={})
    fcns[:increment] = fcns[:x_cal]
    fcns[:x_abs].each_index do |i|
      fcns[:increment][i] = fcns[:x_cal][i] - fcns[:x_abs][i]
    end
    return fcns
  end
  
  def inc_err_perc(fcns={})
    fcns[:inc_err_perc] = fcns[:x_cal]
    fcns[:x_abs].each_index do |i|
      fcns[:inc_err_perc][i] = (100*(fcns[:x_cal][i] - fcns[:x_abs][i])/fcns[:x_abs][i]).abs
    end
    return fcns
  end
  
  private
  
  @@rosenbrock = lambda do |x|
    raise "Dimension error" unless x.size == 2
    (10*(x[1] - x[0]**2))**2 + (1 - x[0])**2
  end
  
  @@freudenstein_and_roth = lambda do |x|
    raise "Dimension error" unless x.size == 2
    (-13 + x[0] + ( (5 - x[1])*x[1] - 2 )*x[1])**2 + ( -29 + x[0] + ( (x[1] + 1)*x[1] -14 )*x[1])**2
  end
  
  @@powell_badly_scaled = lambda do |x|
    raise "Dimension error" unless x.size == 2
    (10**4*x[0]*x[1] - 1)**2 + (Math::exp(-x[0]) + Math::exp(-x[1]) - 1.0001)**2
  end
  
  @@brown_badly_scaled = lambda do |x|
    raise "Dimension error" unless x.size == 2
    (x[0] - 1e6)**2 + (x[1] - 2e-6)**2 + (x[0]*x[1] - 2)**2
  end
  
  @@beale = lambda do |x|
    raise "Dimension error" unless x.size == 2
    (1.5 - x[0]*(1-x[1]))**2 + (2.25 - x[0]*(1-x[1]**2))**2 + (2.625 - x[0]*(1-x[1]**3))**2
  end
  
  @@jennrich_and_sampson = lambda do |x|
    raise "Dimension error" unless x.size == 2
    fcn = 0.0
    10.times do |j|
      i = j + 1
      fcn += ( 2+2*i - ( Math::exp(i*x[0]) + Math::exp(i*x[1])  ) )**2
    end
    fcn
  end
  
  @@helical_valley = lambda do |x|
    raise "Dimension error" unless x.size == 3
    theta = 1/Math::PI*Math::atan(x[1]/x[0])
    theta += 1/2 if x[0] < 0
    ( 10*(x[2]-10*theta) )**2 + ( 10*((x[0]**2 + x[1]**2)**0.5 - 1) )**2 + x[2]**2
  end
  
  @@bard = lambda do |x|
    raise "Dimension error" unless x.size == 3
    y = [0.14, 0.18, 0.22, 0.25, 0.29, 0.32, 0.35, 0.39, 0.37, 0.58, 0.73, 0.96, 1.34, 2.10, 4.39]
    fcn = 0.0
    15.times do |j|
      i = j + 1
      v = 16 - i
      w = [i, v].min
      fcn += (y[j] - ( x[0] + i/(v*x[1] + w*x[2]) ))**2
    end
    fcn
  end
  
  @@gaussian = lambda do |x|
    raise "Dimension error" unless x.size == 3
    y = [0.0009, 0.0044, 0.0175, 0.0540, 0.1295, 0.24020, 0.3521, 0.3989, 0.3521, 0.2420, 0.1295, 0.0540, 0.0175, 0.0044, 0.0009]
    fcn = 0.0
    15.times do |j|
      i = j + 1
      t = (8-i)/2
      fcn += ( x[0]*Math::exp(-x[1]*(t-x[2])**2/2) - y[j] )**2
    end
    fcn
  end
end # module Functions





# References:
# [1] Hillstrom, K.E. A simulation test approach to the evaluation of nonlinear optimization algorithms. ACM Trans. Math. Softw. 3, 4 (1977), 305-315