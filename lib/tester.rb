#!/usr/bin/env ruby
#  tester
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-04-24.
#  Copyright (c) 2011 University of Trento. All rights reserved.
#

require 'rubygems'
require 'gnuplotr'
#require '../algorithms/genetic_algorithm'
#require '../algorithms/nmm'
require '../lib/functions'

class Tester
  include Functions
  def initialize(args = {})
    @cfg = {
      :n_fcns    => "all",      # number of test functions that will be evaluated
      :seach_dom => [-10,10], #domain of values associated to the first trial solution
      :res_file  => "results.dat",
      :plot      => true,
      :plotopt   => {:yrange => [ 0 , 10 ],
                     :title  => "Optimiser performance plot (dimension)"
      }
    }
    @cfg.merge! args
    # based on the number of functions chosen to the test, load the function library
    @fcns = load_fcns(@cfg[:n_fcns]) # it is an array with the name of all functions that will be tested
    File.open(@cfg[:res_file], 'w'){ |file| file.puts "Number of tested functions #{@cfg[:n_fcns]}, starting domain: #{@cfg[:seach_dom]}
Class of test functions:\nnls = nonlinear last squares\numi = unconstrained minimisation\nsne = systems of nonlinear equations\n
#{@fcns.count} functions are tested:\nn\tname\tdimension\titerations\ttime_[s]\tx_exact\tx_calculated\tincrement\tf_exact\tf_calculated\tresidual\tstart_search\tmultiple_minima" }
  
  @non_eval_fcns = []
  end
  
  def test(extr_out)
    raise ArgumentError, "Block needed" unless block_given?
    n = 1
    @fcns.count == 1 ? auxstr = "it is" : auxstr = "they are"
    puts "_"*60
    puts "_"*60
    puts "#{@fcns.count} functions will be tested, "+auxstr+":"
    @fcns.each_key{ |k| puts k.to_s }
    puts "_"*60
    puts "_"*60
    
    @fcns.each do |k,f|
      start_dom = {}
      dim = f[:x_abs].count            # domain dimension of f
      
      dim.times do |i|
        start_dom[i.to_s.to_sym] = @cfg[:seach_dom]
      end
      
      opt = yield(start_dom)           # sets the optimisation algorithm
      puts "Optimising the #{k.to_s.upcase} function\nthe starting domain is #{start_dom.inspect}"
      
      f[:name]  = k.to_s
      start_t   = Time.now
      f[:dim]   = f[:x_abs].count      # is the dimension of the function domain
      begin
        opt.loop(h={}){|x| f[:f].call(x)}# runs the optimisation loop
        f[:time]  = Time.now - start_t   # evaluates the time required to converge
        res = extr_out.call(opt)         # extracts the results
        f[:x_cal] = res[0]               # extracts the abscissae of the solution
        f[:f_cal] = res[1]               # extracts the ordinate of the solution
        f[:n_it]  = res[2]               # extracts the number of iterations made
        residual(f)                      # evaluates the residual error
        res_err_perc(f)                  # evaluates the percentual error on residual
        increment(f)                     # evaluates the increment error
        inc_err_perc(f)                  # evaluates the percentual error on increment
        log(f, n)
        n += 1
      rescue
        @non_eval_fcns << k
        puts "#{k} function no evaluated in the given starting domain"
      end
    end # fcns.each
    #log( @fcns )
    plot
  end

  private
  
  def log(hash={}, n = 1)
    # the starting domain is considered far from the exact solution if...
    hash[:x_abs].min < @cfg[:seach_dom].min || hash[:x_abs].max > @cfg[:seach_dom].max ? start_search = "far" : start_search = "near"
    hash.key?(:x_loc) ? str_mul = "MULTIPLE MINIMA: #{hash[:x_loc]} #{hash[:f_loc]}" :  str_mul = " ABSOLUTE MINIMUM"
    str = ""
    [ :name, :dim, :n_it, :time, :x_abs, :x_cal, :increment, :f_abs, :f_cal, :residual ].each do |k|
      str += "#{hash[k]}\t"
    end
    File.open(@cfg[:res_file], "a") do |file|
      file.print "#{n}\t" + str + "#{start_search}\t#{str_mul}\n"
    end
  end

  def plot
    x = :residual # <-- set this for the plot
    y = :n_it 
    x_test = true
    n_it = []
    @fcns.each do |k,v|
      next if @non_eval_fcns.include? k
      x_test = false unless v.key? x
      n_it << v[y]
    end
    raise ArgumentError, "Wrong output chosen for plot" unless x_test
     i = 2 ; str_plot = "" ; str_name = "" ; str_x = "" ; str_y = ""
    @fcns.each do |k,v|
      next if @non_eval_fcns.include? k
      str_name += "#{v[:name]}(#{v[:dim]})\t"
      str_x += "#{v[x].abs}\t"
      str_y += "#{v[y].to_i}\t"
      if i <= @fcns.count
        str_plot += " , '' using #{i} ti col"
        i += 1
      end
    end

    File.open("dataplot_x.dat","w") do |file|
      file.print str_name + "\n"
      file.print str_x
    end
    File.open("dataplot_y.dat","w") do |file|
      file.print str_name + "\n"
      file.print str_y
    end
    
    File.open("cfgplot.dat", "w") do |file|
      file.print "reset
set terminal aqua size 1200,900
set tmargin 10
set border 3 front linetype -1 linewidth 1.000
set boxwidth 0.75 absolute
set style fill solid 1.00 border -1
set grid noxtics nomxtics ytics nomytics  \\
   nox2tics nomx2tics noy2tics nomy2tics nocbtics nomcbtics
set style histogram columnstacked title  offset character 0, 0, 0
set datafile missing '-'
set style data histograms
set xtics border in scale 1,0.5 nomirror rotate by -45  offset character 0, 0, 0
set ytics border in scale 0,0 mirror norotate  offset character 0, 0, 0 autofreq
set title \"#{@cfg[:plotopt][:title]}\"
set xlabel \"#{@cfg[:plotopt][:xlabel]}\"
set multiplot
set origin 0.0, 0.45
set size 1.0,0.7
set ylabel \"#{x.to_s}\"
set yrange [#{@cfg[:plotopt][:yrange][0]} : #{@cfg[:plotopt][:yrange][1]}]
plot 'dataplot_x.dat' using 1 ti col" + str_plot +"
set origin 0.0, -0.05
set size 1.0,0.7
set ylabel \"Iterations\"
set yrange [0 : #{n_it.max+50}]
plot 'dataplot_y.dat' using 1 ti col" + str_plot +"
\nexit"
    end
    system "gnuplot < cfgplot.dat"
    sleep 0.1
    system "rm dataplot_x.dat dataplot_y.dat cfgplot.dat"
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
