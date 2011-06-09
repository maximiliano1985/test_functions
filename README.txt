#  README.txt
#
#  Created by Carlos Maximiliano Giorgio Bort on 2011-04-24.
#  Copyright (c) 2011 University of Trento. All rights reserved.

Requirements for the algorithm:
a) The algorithm must have a method "sorted" that allows to read the array/hash containing the variabile X (a number, array or vector) and f(X) for each iteration. This is used in the "extract_out" procedure.
b) The algorithm must have a methods (called by whatever name) that allows to read the number of iterations made. This is used in the "extract_out" procedure.

How to use the tester:
see the file test.rb, here you will see the following parts:

1) Tester initialization:
Tester.new(:n_fcns => XXX) XXX is the number of functions chosen for the test. All the available test functions will be tested if XXX is set to "all" or a number higher than the counts of available functions.

2) extract the results:
you must define the procedure necessary to obtain an array with, in order:
[ abscissae of the calculated minimum , ordinate of the calculated minimum , number of iterations made ]

3) use the test method:
you must define a block in which you initialize the MINIMIZATION algorithm. Here the domain of the initial trial set (i.e. :i_o) is set equal to the variable of the given block.

4) run the script from the terminal:
just go on the folder containing the ruby script and type in the terminal
ruby <script_name>.rb