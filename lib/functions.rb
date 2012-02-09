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

# References:
# [1] Hillstrom, K.E. A simulation test approach to the evaluation of nonlinear optimization algorithms. ACM Trans. Math. Softw. 3, 4 (1977), 305-315
# [2] http://extreme.adorio-research.org/download/mvf/html/node3.html update at 04/06/2011
=end

INF = 1e6
PI = Math::PI

module Functions
  
  def load_fcns( n_fcns = "all" ) # list of all the test functions
    @functions = {
      :beale => {      :f     => @@beale,
                       :class => "umi",
                       :start => [1,1],
                       :x_abs => [3, 0.5],
                       :f_abs => 0.0
      },
      :bohachevsky => {:f     => @@bohachevsky,
                       :class => "nls",
                       :start => [10.0,-10.0],
                       :x_abs => [0.0, 0.0],
                       :f_abs => 0.0
      },
      :booth => {      :f     => @@booth,
                       :class => "nls",
                       :start => [10.0,-10.0],
                       :x_abs => [1.0, 3.0],
                       :f_abs => 0.0
      },
      :branin => {      :f     => @@branin,
                       :class => "umi",
                       :start => [10,10],
                       :x_abs => [0.402357, 0.287408],
                       :f_abs => 2.4554038264861466e-07 # the exact solution is 0.0
      },
      :brown_badly_scaled => {
                       :f     => @@brown_badly_scaled,
                       :class => "umi",
                       :start => [1, 1],
                       :x_abs => [1e6, 2e-6],
                       :f_abs => 0.0
      },
      :chichinadze => {:f     => @@chichinadze,
                       :class => "nls",
                       :start => [30.0,-10.0],
                       :x_abs => [5.90133, 0.5],
                       :f_abs => -43.31586206998933
      },
      :easom => {      :f     => @@easom,
                       :class => "umi",
                       :start => [-60,70],
                       :x_abs => [PI, PI],
                       :f_abs => -1.0
      },
      :freudenstein_and_roth => {
                       :f     => @@freudenstein_and_roth,
                       :class => "nls",
                       :start => [0.5, -2],
                       :x_abs => [5, 4],
                       :f_abs => 0.0,
                       :x_loc => [11.41, -0.8968],
                       :f_loc => 48.98426991859543
      },
      :goldstein_price => {
                       :f     => @@goldstein_price,
                       :class => "nls",
                       :start => [2.0, -2.0],
                       :x_abs => [0.0, -1.0],
                       :f_abs => -3.0
      },
      :jennrich_and_sampson => {
                       :f     => @@jennrich_and_sampson,
                       :class => "nls",
                       :start => [0.3,0.4],
                       :x_abs => [0.2578, 0.2578],
                       :f_abs => 124.36226865912342
      },
      :himmelblau  => {:f     => @@himmelblau,
                       :class => "nls",
                       :start => [-6.0, 6.0],
                       :x_abs => [3.0, 2.0],
                       :f_abs => 0.0
      },
      :hosaki => {     :f     => @@hosaki,
                       :class => "nls",
                       :start => [-6.0, 6.0],
                       :x_abs => [4.0, 2.0],
                       :f_abs => -2.345811576101292
      },
      :powell_badly_scaled => {
                       :f     => @@powell_badly_scaled,
                       :class => "sne-umi",
                       :start => [0, 1],
                       :x_abs => [1.09815933e-5, 9.106146738],
                       :f_abs => 4.675406311877606e-21
      },
      :rosenbrock => { :f     => @@rosenbrock,
                       :class => "sne-nls",
                       :start => [-1.2, 1], # first trial point
                       :x_abs => [1,1],     # absolute minimum abscissae
                       :f_abs => 0.0        # absolute minimum ordinate
      },
      :trefethen_4 => {:f     => @@trefethen_4,
                       :class => "nls",
                       :start => [-6.0, 3.5],
                       :x_abs => [-0.0244031, 0.2106124],
                       :f_abs => -3.3068686474703033
      },
      :zettl => {      :f     => @@zettl,
                       :class => "nls",
                       :start => [-6.0, 3.5],
                       :x_abs => [-0.02990, 0.0],
                       :f_abs => -0.0037912371501199
      },
      :bard => {       :f     => @@bard,
                       :class => "nls",
                       :start => [1.0]*3,
                       :x_abs => [0.0824106, 1.13304, 2.3437],
                       :f_abs => 0.008214877468756064
      },
      :box_betts => {  :f     => @@box_betts,
                       :class => "nls",
                       :start => [-3.0,1.0,3.0],
                       :x_abs => [1.0, 10.0 ,1.0],
                       :f_abs => 0.0
      },
      :gaussian => {   :f     => @@gaussian,
                       :class => "umi",
                       :start => [0.4, 1, 0],
                       :x_abs => [0.398956, 1.0, 0.0],
                       :f_abs => 1.12793e-8
      },
      :helical_valley => {
                       :f     => @@helical_valley,
                       :class => "sne-nls",
                       :start => [-1.0,0.0,0.0],
                       :x_abs => [ 1.0,0.0,0.0],
                       :f_abs => 0.0
      },
      :holzman => {    :f     => @@holzman,
                       :class => "sne-nls",
                       :start => [40.0, 22.0, 3.0],
                       :x_abs => [ 50.0, 25.0, 1.5],
                       :f_abs => 0.0
      },
      :wood => {       :f     => @@wood,
                       :class => "umi",
                       :start => [-3.0, -1.0, -3.0, -1.0],
                       :x_abs => [1.0]*4,
                       :f_abs => 0.0
      },
      :ackley => {     :f     => @@ackley,
                       :class => "umi",
                       :start => [-30.0, -10.0, -30.0, -10.0],
                       :x_abs => [0.0]*4,
                       :f_abs => 4.440892098500626e-16 # the exact solution is 0.0
      },
      :coville => {    :f     => @@coville,
                       :class => "umi",
                       :start => [-10.0, 10.0, -10.0, -10.0],
                       :x_abs => [1.0]*4,
                       :f_abs => 0.0
      },
      :kowalik_and_osborne => {
                       :f     => @@kowalik_and_osborne,
                       :class => "umi",
                       :start => [0.25, 0.39, 0.415, 0.39],
                       :x_abs => [0.192833, 0.190836, 0.123117, 0.135766],
                       :f_abs => 3.0748610e-4
      },
      :osborne_1 => {  :f     => @@osborne_1,
                       :class => "umi",
                       :start => [0.5, 1.5, -1, 0.01, 0.02],
                       :x_abs => [0.3754, 1.9358, -1.4647, 0.01287, 0.02212],
                       :f_abs => 5.533356734067436e-05 # the exact solution is 5.46489e-5
      },
      :plateau => {    :f     => @@plateau,
                       :class => "umi",
                       :start => [4.0, 3.0, -1.0, -2.0, -5.0],
                       :x_abs => [0.0]*5,
                       :f_abs => 30.0
      },
      :biggs_exp6 => { :f     => @@biggs_exp6,
                       :class => "umi",
                       :start => [1.0, 2.0, 1.0, 1.0, 1.0, 1.0],
                       :x_abs => [1.0, 10.0, 1.0, 5.0, 4.0, 3.0],
                       :f_abs => 0.0,
                       :x_loc => [0.0]*6,
                       :f_loc => 5.65565e-3
      },
      :levy => {       :f     => @@levy,
                       :class => "umi",
                       :start => [0.0]*6,
                       :x_abs => [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, -4.754402],
                       :f_abs => -11.50440302132809
      },
      :rastrigin => {  :f     => @@rastrigin,
                       :class => "umi",
                       :start => [5.0]*6,
                       :x_abs => [0.0]*6,
                       :f_abs => 0.0
      },
      :watson => {     :f     => @@watson,
                       :class => "umi",
                       :start => [0.0]*6,
                       :x_abs => [-0.0158, 1.012, -0.2329, 1.260, -1.513, 0.9928],
                       :f_abs => 0.002297347610747973 # the exact solution is 2.28767e-3
      },
      :griewank => {     :f     => @@griewank,
                       :class => "umi",
                       :start => [450.0]*10,
                       :x_abs => [0.0]*10,
                       :f_abs => 0.0
      },
      :neumaier => {   :f     => @@neumaier,
                       :class => "umi",
                       :start => [5.0]*10,
                       :x_abs => [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0],
                       :f_abs => 0.0
      },
      :osborne_2 => {  :f     => @@osborne_2,
                       :class => "umi",
                       :start => [1.3, 0.65, 0.65, 0.7, 0.6, 3, 5, 7, 2, 4.5, 5.5],
                       :x_abs => [1.31,0.4315,0.6336,0.5993,0.7539,0.9056,1.3651,4.8248,2.3988,4.5689,5.6754],
                       :f_abs => 0.040137874050765625
      },
      :maxmod => {     :f     => @@maxmod,
                       :class => "umi",
                       :start => [450.0]*15,
                       :x_abs => [0.0]*15,
                       :f_abs => 0.0
      },
=begin
      :paviani => {   :f     => @@paviani,
                       :class => "umi",
                       :start => [5.0]*10,
                       :x_abs => [9.340266]*10,
                       :f_abs => -45.775244337147264
      },
=end
      :powell => {     :f     => @@powell,
                       :class => "umi",
                       :start => [3.0, -1.0, 0.0, 1.0]*4,
                       :x_abs => [0.0]*16,
                       :f_abs => 0.0
      }
=begin
      :gulf_reseach_development => {
                       :f     => @@gulf_reseach_development,
                       :class => "umi",
                       :start => [5.0, 2.5, 0.15],
                       :x_abs => [50.0, 25.0, 1.5],
                       :f_abs => 0.0
      },
      :meyer => {      :f     => @@meyer,
                       :class => "umi",
                       :start => [0.02, 4000, 250],
                       :x_abs => [0,0,0],############## ambiguities here
                       :f_abs => 87.9458
      },
     :brown_and_dennis => {
                       :f     => @@brown_and_dennis,
                       :class => "umi",
                       :start => [25, 5, -5, -1],
                       :x_abs => [0, 0, 0, 0], ############## ambiguities here
                       :f_abs => 85822.2
      },
=end  
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
    fcns[:increment] = fcns[:x_abs]
    fcns[:x_abs].each_index do |i|
    fcns[:increment][i] = fcns[:x_cal][i] - fcns[:x_abs][i]
    end
    return fcns
  end
  
  def inc_err_perc(fcns={})
    fcns[:inc_err_perc] = fcns[:x_abs]
    fcns[:x_abs].each_index do |i|
      fcns[:inc_err_perc][i] = (100*(fcns[:x_cal][i] - fcns[:x_abs][i])/fcns[:x_abs][i]).abs
    end
    return fcns
  end
  
  private
  ######### from reference [1]
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
    y = [0.0009, 0.0044, 0.0175, 0.0540, 0.1295, 0.2420, 0.3521, 0.3989, 0.3521, 0.2420, 0.1295, 0.0540, 0.0175, 0.0044, 0.0009]
    fcn = 0.0
    15.times do |j|
      i = j.to_f + 1.0
      t = (8.0-i)/2.0
      fcn += (x[0]*Math.exp( (-(x[1]*(t-x[2])**2.0))/2.0 ) - y[j])**2
    end
    fcn
  end
  
  @@meyer = lambda do |x|
    raise "Dimension error" unless x.size == 3
    y = [ 34780, 28610, 23650, 19630, 16370, 13720, 11540, 9744, 8261, 7030, 6005, 5147, 4427, 3820, 3307, 2872 ]
    fcn = 0.0
    16.times do |j|
      i = j + 1
      t = 45 + 5*i
      fcn += x[0]*Math::exp( x[1]/(t+x[2]) ) - y[j]
    end
    fcn
  end
  
  @@gulf_reseach_development  = lambda do |x|
    raise "Dimension error" unless x.size == 3
    fcn = 0.0
    97.times do |j|
      i = j + 1 + 2 # i.e. n <= m <= 100 ( with n = 3 )
      t = i.to_f / 100.0
      m = 3.0
      y = 25.0 + ( -50.0*Math::log( t ) )**(2.0/3.0)
      fcn += (Math::exp( -( (y*m*i*x[1]).abs )**x[2]/x[0] ))**2
    end
    fcn
  end
  
  @@wood = lambda do |x|
    raise "Dimension error" unless x.size == 4
    f_1 = 10*(x[1]-x[0]**2)
    f_2 = 1-x[0]
    f_3 = 90**0.5*( x[3] - x[2]**2 )
    f_4 = 1- x[2]
    f_5 = 10**0.5*( x[1] + x[3] -2 )
    f_6 = 10**(-0.5)*( x[1] - x[3] )
    f_1**2 + f_2**2 + f_3**2 + f_4**2 + f_5**2 + f_6**2
  end
  
  @@kowalik_and_osborne = lambda do |x|
    raise "Dimension error" unless x.size == 4
    u = [ 4.0, 2.0, 1.0, 0.5, 0.25, 0.167, 0.125, 0.1, 0.0833, 0.0714, 0.0625]
    y = [ 0.1957, 0.1947, 0.1735, 0.1600, 0.0844, 0.0627, 0.0456, 0.0342, 0.0323, 0.0235, 0.0246]
    fcn = 0.0
    u.count.times do |j|
      fcn += ( y[j] - x[0]*( u[j]**2 + u[j]*x[1] )/( u[j]**2 + u[j]*x[2] + x[3] ) )**2
    end
    fcn
  end
  
  @@brown_and_dennis = lambda do |x|
    raise "Dimension error" unless x.size == 4
    fcn = 0.0
    20.times do |j|
      i = j + 1
      t = i/5
      fcn += (( x[0] + t*x[1] -Math.exp(t) )**2 + ( x[2] + x[3]*Math.sin(t) -Math.cos(t) )**2)**2
    end
    fcn
  end
  
  @@osborne_1 = lambda do |x|
    raise "Dimension error" unless x.size == 5
    y = [ 0.844, 0.908, 0.932, 0.936, 0.925, 0.908, 0.881, 0.850, 0.818, 0.784,
          0.751, 0.718, 0.685, 0.658, 0.628, 0.603, 0.580, 0.558, 0.538, 0.522,
          0.506, 0.490, 0.478, 0.467, 0.457, 0.448, 0.438, 0.431, 0.424, 0.420,
          0.414, 0.411, 0.406 ]
    fcn = 0.0
    y.count.times do |j|
      t = 10.0*j
      fcn += (y[j] - ( x[0] + x[1]*Math.exp(-t*x[3]) + x[2]*Math.exp(-t*x[4]) ))**2.0
    end
    fcn
  end
  
  @@osborne_2 = lambda do |x|
    raise "Dimension error" unless x.size == 11
    y = [ 1.366, 1.191, 1.112, 1.013, 0.991, 0.885, 0.831, 0.847, 0.786, 0.725,
          0.746, 0.679, 0.608, 0.655, 0.616, 0.606, 0.602, 0.626, 0.651, 0.724,
          0.649, 0.649, 0.694, 0.644, 0.624, 0.661, 0.612, 0.558, 0.533, 0.495,
          0.500, 0.423, 0.395, 0.375, 0.372, 0.391, 0.396, 0.405, 0.428, 0.429,
          0.523, 0.562, 0.607, 0.653, 0.672, 0.708, 0.633, 0.668, 0.645, 0.632,
          0.591, 0.559, 0.597, 0.625, 0.739, 0.710, 0.729, 0.720, 0.636, 0.581,
          0.428, 0.292, 0.162, 0.098, 0.054 ]
    fcn = 0.0
    y.count.times do |j|
      t = j/10.0
      fcn +=( y[j] - ( x[0]*Math.exp(-t*x[4]) +x[1]*Math.exp(-x[5]*(t-x[8])**2) +
             x[2]*Math.exp(-x[6]*(t-x[9])**2) + x[3]*Math.exp(-x[7]*(t-x[10])**2) ))**2
    end
    fcn
  end
  
  @@biggs_exp6 = lambda do |x|
    raise "Dimension error" unless x.size == 6
    fcn = 0.0
    13.times do |j|
      i = j + 1
      t = 0.1*i
      y = Math.exp(-t) - 5.0*Math.exp(-10.0*t) + 3.0*Math.exp(-4.0*t)
      fcn += x[2]*Math.exp(-t*x[0]) - x[3]*Math.exp(-t*x[1]) + x[5]*Math.exp(-t*x[4]) - y
    end
    fcn
  end
  
  @@watson = lambda do |x|
    raise "Dimension error" unless x.size == 6 # "n" can be: 6, 9, 12. Here is set to 6 
    fcn = 0.0
    29.times do |k|
      t = (k + 1.0)/29.0
      sum1 = 0.0 ; sum2 = 0.0
      x.count.times{ |j| next if j == 0 ; sum1 += j*x[j]*t**(j-1)}
      x.count.times{ |j| sum2 += x[j]*t**j}
      fcn += ( sum1 - sum2**2.0 - 1.0 )**2.0
    end
    fcn + x[0]**2.0 + (x[1] - x[0]**2.0 - 1.0)**2.0 
  end
  
  ######### from reference [2]
  
  @@bohachevsky = lambda do |x|
    raise "Dimension error" unless x.size == 2
    x[0]**2 + 2.0*x[1]**2 - 0.3*Math.cos(3*PI*x[0]) - 0.4*Math.cos(4*PI*x[1]) + 0.7
  end
  
  @@booth = lambda do |x|
    raise "Dimension error" unless x.size == 2
    ( x[0] + 2*x[1] -7 )**2 + ( 2*x[0] + x[1] - 5 )**2
  end
  
  @@ackley = lambda do |x|
    raise "Dimension error" unless x.size == 4
    a = 0.0 ;  b = 0.0
    n = x.count
    x.each{ |v| a += v**2 ; b += Math.cos(2*PI*v) }
    - 20*Math.exp(-0.2*(a/n)**0.5) - Math.exp(b/n) + 20 + Math.exp(1)
  end
  
  @@box_betts = lambda do |x|
    raise "Dimension error" unless x.size == 3
    fcn = 0.0
    x.count.times do |i|
      fcn += (  Math.exp(-0.1*x[0]*(i+1)) -Math.exp(-0.1*x[1]*(i+1)) - ( Math.exp(-0.1*(i+1)) - Math.exp(-(i+1)) )*x[2]  )**2
    end
    fcn
  end
  
  @@branin = lambda do |x|
    raise "Dimension error" unless x.size == 2
    (1.0 - 2.0*x[1] + Math.sin(4.0*PI*x[1])/20.0 - x[0])**2 + (x[1] - Math.sin(2.0*PI*x[0])/2.0)**2
  end
  
  @@chichinadze = lambda do |x|
    raise "Dimension error" unless x.size == 2
    x[0]**2 - 12*x[0] + 11 + 10*Math.cos(PI/2*x[0]) + 8*Math.sin(5*PI*x[0]) - 1/(5**0.5)*Math.exp(-0.5*(x[1] - 0.5)**2)
  end
  
  @@coville = lambda do |x|
    raise "Dimension error" unless x.size == 4
    100*(x[0] - x[1]**2)**2 + (1 - x[0])**2 + 90*(x[3] - x[2]**2)**2 + (1 - x[2])**2 + 10.1*((x[1] - 1)**2 + (x[3] - 1)**2) + 19.8*(x[1] - 1)*(x[3] - 1)
  end
  
  @@easom = lambda do |x|
    raise "Dimension error" unless x.size == 2
    - Math.cos(x[0])*Math.cos(x[1])*Math.exp( - (x[0] - PI)**2 - (x[1] - PI)**2 )
  end
  
  @@goldstein_price = lambda do |x|
    raise "Dimension error" unless x.size == 2
    ( 1 + (x[0] + x[1] + 1)**2*(19 - 14*x[0] + 3*x[0]**2 - 14*x[1] +6*x[0]*x[1] + 3*x[1]**2))*(18 - 32*x[0] + 12*x[0]**2 + 48*x[1] - 36*x[0]*x[1] + 27*x[1]**2)
  end
  
  @@griewank = lambda do |x|
    raise "Dimension error" unless x.size == 10
    fcn_s = 0.0 ; fcn_p = 0.0
    x.count.times do |i|
      fcn_s += (x[i] - 1.0 )**2
      fcn_p *= Math.cos( (x[i]-100.0)/((i+1)**0.5) )
    end
    fcn_s/10 - fcn_p - 1
  end
  
  @@himmelblau = lambda do |x|
    raise "Dimension error" unless x.size == 2
    (x[0]**2 + x[1] - 11)**2 + (x[0] + x[1]**2 -7)**2 
  end
  
  @@holzman = lambda do |x|
    raise "Dimension error" unless x.size == 3
    fcn = 0.0
    #99.times do |i|
    #  u = 25 + ( -50*Math.log( 0.01*( i + 1 ) ) )**(2/3)
    #  a = [0, x[2]].max
    #  b = [0.1, x[0]].max
    #  puts "-"*40
    #  puts  (u - x[1])
    #  fcn += -0.1*(i + 1) + Math.exp( 1/b*(u - x[1])**a )
    #end
    x.count.times{ |i| fcn += i*x[i]**4 }
    fcn
  end
  
  @@hosaki = lambda do |x|
    raise "Dimension error" unless x.size == 2
    ( 1.0 - 8.0*x[0] +7.0*x[0]**2.0 - 7.0/3.0*x[0]**3.0 + 1.0/4.0*x[0]**4.0)*x[1]**2.0*Math.exp(-x[1])
  end
  
  @@levy = lambda do |x|
    raise "Dimension error" unless x.size == 7
    fcn = 0.0
    (x.count-1).times{ |i| fcn += ( x[i] - 1 )**2*( 1 + Math.sin(3*PI*x[i+1])**2 ) }
    Math.sin(3*PI*x[0])**2 + fcn + ( x[6] - 1 )*(1 + Math.sin(2*PI*x[6])**2 )
  end
  
  @@maxmod = lambda do |x|
    raise "Dimension error" unless x.size == 15
    fcn = []
    x.each{ |v| fcn << v.abs }
    fcn.max
  end
  
  @@neumaier = lambda do |x|
    raise "Dimension error" unless x.count == 10
    beta = 1e7
    fcn = 0.0
    x.count.times do |k|
      fcn_i = 0.0
      x.count.times{ |i| fcn_i += ( (i+1)**(k+1) + beta )*( (x[i]/(i+1))**(k+1) - 1 ) }
      fcn += fcn_i**2
    end
    fcn  
  end
  
  @@paviani  = lambda do |x|
    raise "Dimension error" unless x.count == 10
    fcn_s = 0.0 ; fcn_p = 1.0
    x.each do |v|
      x_i = [ v, 2.0001].max
      x_i = [ x_i, 9.9999].min
      fcn_s += ( Math.log(x_i - 2.0) )**2.0 + ( Math.log( 10.0 - x_i ) )**2.0
      fcn_p *= v
    end
    fcn_s - fcn_p**0.2
  end
  
  @@plateau = lambda do |x|
    raise "Dimension error" unless x.count == 5
    fcn = 0.0
    x.count.times{|i| fcn += x[i]}
    fcn + 30
  end
  
  @@powell = lambda do |x|
    raise "Dimension error" unless x.count == 16
    fcn = 0.0
    (x.count/4).times do |i|
      j = i + 1.0
      fcn += (x[4*j-4] + 10.0*x[4*j-3])**2.0 + 5.0*(x[4*j-2] - x[4*j-1])**2.0 + (x[4*j-3] - 2.0*x[4*j-2])**4.0 + 10.0*(x[4*j-4] - x[4*j-1])**4.0
    end
    fcn
  end
  
  @@rastrigin = lambda do |x|
    raise "Dimension error" unless x.count == 6
    fcn = 0.0
    x.count.times{ |i| fcn += x[i]**2 - 10*Math.cos(2*PI*x[i]) + 10 }
    fcn
  end

  @@trefethen_4 = lambda do |x|
    raise "Dimension error" unless x.count == 2
    Math.exp(Math.sin(50.0*x[0])) + Math.sin(60.0*Math.exp(x[1])) + Math.sin(70.0*Math.sin(x[0])) + Math.sin(Math.sin(80.0*x[1])) - Math.sin(10.0*(x[0]+x[1])) + 1.0/4.0*(x[0]**2+x[1]**2)
  end
  
  @@zettl = lambda do |x|
    raise "Dimension error" unless x.count == 2
    (x[0]**2 + x[1]**2 - 2*x[0])**2 + 0.25*x[0]
  end
  
end # module Functions