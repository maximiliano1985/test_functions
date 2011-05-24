#!/usr/bin/env ruby
#  tester
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-04-24.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#

require 'rubygems'
require 'gnuplotr'
require 'genetic_algorithm'
require '../lib/functions'

class Tester
  include Functions
  def initialize(args = {})
    @cfg = {
      :n_fcns => "all",      # number of test functions that will be evaluated
      :seach_dom => [-10,10] #domain of values associated to the first trial solution
    }
    @cfg.merge! args
    # based on the number of functions chosen to the test, load the function library
    @fcns = load_fcns(@cfg[:n_fcns]) # it is an array with the name of all functions that will be tested
    @file_name = "../results.txt"
    File.open(@file_name, "w"){ |file| file.puts "Number of tested functions #{@cfg[:n_fcns]}, starting domain: #{@cfg[:seach_dom]}
Class of test functions:\nnls = nonlinear last squares\numi = unconstrained minimisation\nsne = systems of nonlinear equations\n
n name class iterations time_[s] x_exact f_exact x_calculated f_calculated residual start_search" }
  end
  
  def test(extr_out)
    raise ArgumentError, "Block needed" unless block_given?
    n = 1
    @fcns.count == 1 ? auxstr = "it is" : auxstr = "they are"
    puts "_"*60
    puts "#{@fcns.count} functions will be tested, "+auxstr+":"
    @fcns.each_key{ |k| puts k.to_s }
    puts "_"*60
    
    ######### fare un metodo che imposti il primo tentativo
    @fcns.each do |k,f|
      has = {} ; start_dom = {}
      dim = f[:x_abs].count            # domain dimension of f
      dim.times do |i|
        start_dom[i.to_s.to_sym] = @cfg[:seach_dom]
      end
      opt = yield(start_dom)          # sets the optimisation algorithm
      f[:name] = k.to_s
      start_t = Time.now
      opt.loop(has){|x| f[:f].call(x)} # runs the optimisation loop
      f[:time] = Time.now - start_t    # evaluates the time required to converge
      res = extr_out.call(has)         # extracts the results
      f[:x_cal] = res[0]               # extracts the abscissae of the solution
      f[:f_cal] = res[1]               # extracts the ordinate of the solution
      f[:n_it]  = res[2]               # extracts the number of iterations made
      residual(f)
      log( f, n )
      n += 1
    end # fcns.each
    
  end
  
  def log(hash={}, n = 1)
    # the starting domain is considered far from the exact solution if...
    hash[:x_abs].min < @cfg[:seach_dom].min || hash[:x_abs].max > @cfg[:seach_dom].max ? start_search = "far" : start_search = "near"
    File.open(@file_name, "a") do |file|
      file.print "#{n} #{hash[:name]} #{hash[:class]} #{hash[:n_it]} #{hash[:time]} #{hash[:x_abs]} #{hash[:f_abs]}   #{hash[:x_cal]} #{hash[:f_cal]}  #{hash[:residual]} #{start_search}\n"
    end
  end
end 

if __FILE__ == $0
  # Instantiate the optimizer, with tolerance and dimension
=begin
  opt = GA::Optimizer.new( :tol => 1E-3,
    :p_mutation  => 0.2,
    :p_crossover => 0.8,
    :npop        => 200,
    :ncr         => 150,
    :pconv       => false
  )
=end
  tester = Tester.new(:n_fcns => "all")
  extract_out = lambda do |a| # procedure used to extract the solution from the array of iterations
    out_hash = a[(a.count-1).to_s.to_sym].first
    [out_hash[:chromosome], out_hash[:fitness], a.count]
  end  
  tester.test( extract_out ) do |domain| # block used to adapt the function domain dinamically
    raise "Hash needed" unless domain.class == Hash
    opt = GA::Optimizer.new( :tol => 1E-3,
    :p_mutation  => 0.2,
    :p_crossover => 0.8,
    :npop        => 200,
    :ncr         => 150,
    :pconv       => false,
    :i_o         => domain
    )
  end
end
