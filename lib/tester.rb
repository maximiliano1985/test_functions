#!/usr/bin/env ruby
#  tester
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-03-06.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#

require 'rubygems'
require 'gnuplotr'
require 'genetic_algorithm'
require '../lib/functions'

class Tester
  include Functions
  def initialize(args = {})
    @cfg = {:n_fcns => "all" # number of test functions that will be evaluated
      }
    @cfg.merge! args
    # based on the number of functions chosen to the test, load the function library
    @fcns = load_fcns(@cfg[:n_fcns]) # it is an array with the name of all functions that will be tested
    File.open("../results.txt", "w"){ |file| file.puts "algorithm class n_iterations time residual" }
  end
  
  def test(opt)
    @fcns.count == 1 ? auxstr = "it is" : "they are"
    puts "#{@fcns.count} functions will be tested, "+auxstr+":\n #{@fcns.keys.inspect}"
    
    
    @fcns.each{ |k,f| opt.loop{|x| f.call(x)} }
    
    #puts self.method(fcns[0].to_sym).call([3,4])
    #Functions::metaclass.superclass.method(:rosenbrock).call
    #fcns.each{ |f| opt.loop{|p| f.to_sym.call(p)}}
    #raise "ERROR: none argument passed to the test functions" if x == nil
    #Functions::nonlinear_last_squares( , &block)
  end
  
  def log
  end
end 

if __FILE__ == $0
  # Instantiate the optimizer, with tolerance and dimension
  opt = GA::Optimizer.new( :tol => 1E-3,
    :p_mutation  => 0.2,
    :p_crossover => 0.8,
    :i_o         => { :X =>[-5,10] , :Y=>[-10.23,5.234] },
    :npop        => 50,
    :ncr         => 150,
    :pconv       => false
  )
  #opt.loop{|p| f.call(p)}
  #p opt.iteration
  tester = Tester.new(:n_fcns => 1) 
  tester.test( opt )
end
