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
    @file_name = "../results.txt"
    File.open(@file_name, "w"){ |file| file.puts "Number of tested functions #{@cfg[:n_fcns]}
Class of test functions: nls = nonlinear last squares, umi = unconstrained minimisation, sne = systems of nonlinear equations\n
algorithm class n_iterations time exact_sol exact_f approx_sol approx_f residual" }
  end
  
  def test(opt)
    raise ArgumentError, "Block needed" unless block_given?
    @fcns.count == 1 ? auxstr = "it is" : "they are"
    puts "#{@fcns.count} functions will be tested, "+auxstr+":\n #{@fcns.keys.inspect}"
    
    ######### fare un metodo che imposti il primo tentativo
    ary = {}
    @fcns.each do |k,f|
      start_t = Time.now
      opt.loop(ary){|x| f[:f].call(x)} # runs the optimisation loop
      f[:time] = Time.now - start_t    # evaluates the time required to converge
      res = yield(ary)                 # extracts the results
      f[:x_cal] = res[0]                  # extracts the abscissae of the solution
      f[:f_cal] = res[1]               # extracts the ordinate of the solution
      f[:n_it]  = res[2]               # extracts the number of iterations made
    end # fcns.each
    
    residual(@fcns)
    
    
    #puts self.method(fcns[0].to_sym).call([3,4])
    #Functions::metaclass.superclass.method(:rosenbrock).call
    #fcns.each{ |f| opt.loop{|p| f.to_sym.call(p)}}
    #raise "ERROR: none argument passed to the test functions" if x == nil
    #Functions::nonlinear_last_squares( , &block)
  end
  
  def log(n = 1, hash={})
    File.open(@file_name, "a") do |file|
      file.puts "#{n} #{hash[:f]} #{hash[:class]} #{hash[:n_it]}  #{hash[:time]}  #{hash[:x_abs]}  #{hash[:f_abs]}  #{hash[:x_cal]}  #{hash[:f_cal]}  #{hash[:residual]}"
    end
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
  tester.test( opt ) do |a| # the block is used to extract the solution from the array of iterations
    out_hash = a[(a.count-1).to_s.to_sym].first
    [out_hash[:chromosome], out_hash[:fitness], a.count]
  end
end
