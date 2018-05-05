% crosgrp - crossover between more parents
%
%	Description:
%	The function recombinates more (also more than 2) parents and creates a required 
%	number of offsprings which genes are a random combination of genes of 
%	all parents. The number of parents and offsprings need not be equal.
%
%
%	Syntax:  
%
%	Newgroup=crosgrp(Oldgroup,num)
%
%	         Newgroup - new group of strings
%	         Oldgroup - old group of strings
%	         num -  number of required new strings
     
% I.Sekaj, 2000

function[Newgrp]=crosgrp(Oldgrp,num)

[lgrp,lstring]=size(Oldgrp);

for r=1:num
for s=1:lstring
m=ceil(rand*lgrp);
Newgrp(r,s)=Oldgrp(m,s);
end;
end; 

