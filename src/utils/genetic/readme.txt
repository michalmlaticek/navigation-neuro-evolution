Genetic Algorithm Toolbox for Matlab(R) ver.1.2
----------------------------------------
I.Sekaj, 10/2002
Department of Automatic Control Systems
Faculty of Electrical Engineering and Information Technology
Slovak University of Technology
Ilkovicova 3, 812 19 Bratislava, Slovak Republic
E-mail: ivan.sekaj@stuba.sk

Description:
------------
The Toolbox can be used for solving of real-coded search and optimizing problems.
The Toolbox functions minimizes the objective function, maximizing problems can be 
solved as complementary tasks.


List of functions:
------------------
around - intermediate crossover
change - elimination of duplicite strings in the population
crosgrp - crossover between more parents
crosord - crossover of permutation type string
crossov - multipoint crossover
genrpop - generating of a random real-coded population
invfit - inversion of the objective (fitness) function
invord - inversion of order of a substring 
muta - aditive mutation with uniform probability distribution
mutm - multiplicative mutation
mutn - aditive mutation with normal probability distribution
mutx - simple mutation
selbest - selection of best strings
seldiv - selection based on the maximum diversity measure
selrand - random selection 
selsort - selection and sorting of best string of a population according fitness
selsus - stochastic universal selection
seltourn - tournament selection
selsus - stochastic universal sampling
shake - random shaking of the string order in the population
swapgen - mutation of the gene-order in strings
swappart- exchange of the order of two substrings in the strings
