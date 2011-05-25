#!/usr/bin/env ruby
#  tester
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-04-24.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#

require 'rubygems'
require 'gnuplotr'
require 'genetic_algorithm'
require './lib/functions'

class Tester
  include Functions
  def initialize(args = {})
    @cfg = {
      :n_fcns    => "all",      # number of test functions that will be evaluated
      :seach_dom => [-10,10], #domain of values associated to the first trial solution
      :res_file  => "results.dat",
      :plot      => true,
      :plotopt   => {:xlabel => 'Algorithm',
                          :ylabel => 'Performance: residual + elapsed time',
                          :yrange => [ 0 , 10 ]
      }
    }
    @cfg[:plotopt][:title] = "Optimiser performance plot"
    @cfg.merge! args
    # based on the number of functions chosen to the test, load the function library
    @fcns = load_fcns(@cfg[:n_fcns]) # it is an array with the name of all functions that will be tested
    File.open(@cfg[:res_file], 'w'){ |file| file.puts "Number of tested functions #{@cfg[:n_fcns]}, starting domain: #{@cfg[:seach_dom]}
Class of test functions:\nnls = nonlinear last squares\numi = unconstrained minimisation\nsne = systems of nonlinear equations\n
n name class iterations time_[s] x_exact x_calculated increment inc_err_perc f_exact f_calculated residual res_err_perc start_search" }
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
      residual(f)                      # evaluates the residual error
      res_err_perc(f)                  # evaluates the percentual error on residual
      increment(f)                     # evaluates the increment error
      inc_err_perc(f)                  # evaluates the percentual error on increment
      log( f, n )
      n += 1
    end # fcns.each

     plot
  end

  private

  def log(hash={}, n = 1)
    # the starting domain is considered far from the exact solution if...
    hash[:x_abs].min < @cfg[:seach_dom].min || hash[:x_abs].max > @cfg[:seach_dom].max ? start_search = "far" : start_search = "near"
    str = ""
    [ :name, :class, :n_it, :time, :x_abs, :x_cal, :increment, :inc_err_perc, :f_abs, :f_cal, :residual, :res_err_perc ].each do |k|
      str += "#{hash[k]} "
    end
    File.open(@cfg[:res_file], "a") do |file|
      file.print "#{n} " + str + "#{start_search} \n"
    end
  end

  def plot
    x = :residual
    y = :time
    x_test = true
    @fcns.each_value{|v| x_test = false unless v.key? x}
    raise ArgumentError, "Wrong output chosen for plot" unless x_test
     i = 2 ; str_plot = "" ; str_name = "" ; str_out = ""
    @fcns.each_value do |v|
      str_name += "#{v[:name]} "
      str_out += "#{v[x].abs+v[y]} " # <--------------- set this for the plot
      if i <= @fcns.count
        str_plot += " , '' using #{i} ti col"
        i += 1
      end
    end

    File.open("dataplot.dat","w") do |file|
      file.print str_name + "\n"
      file.print str_out
    end

    File.open("cfgplot.dat", "w") do |file|
      file.print "reset
set border 3 front linetype -1 linewidth 1.000
set boxwidth 0.75 absolute
set style fill   solid 1.00 border -1
set grid noxtics nomxtics ytics nomytics  \\
   nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set style histogram columnstacked title  offset character 0, 0, 0
set datafile missing '-'
set style data histograms
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0
set ytics border in scale 0,0 mirror norotate  offset character 0, 0, 0 autofreq
set title \"#{@cfg[:plotopt][:title]}\"
set xlabel \"#{@cfg[:plotopt][:xlabel]}\"
set yrange [#{@cfg[:plotopt][:yrange][0]} : #{@cfg[:plotopt][:yrange][1]}]
set ylabel \"#{@cfg[:plotopt][:ylabel]}\"
plot 'dataplot.dat' using 1 ti col" + str_plot +"\nexit"
    end
    system "gnuplot < cfgplot.dat"

  end #plot
end # class

if __FILE__ == $0
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
