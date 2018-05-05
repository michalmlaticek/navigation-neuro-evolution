% selsort - selection and sorting of best string of a population
%
%	Descrption:
%	The function selects from the old population into the new population
%	the required number of best strings and also sorts this strings according
% 	their fitness from the most fit to the least fit. The most fit is the string 
%	with the lowest value of the objective function and vice-versa.
%
%
%	Syntax:
%
%	Newpop=selsort(Oldpop,Oldfit,Num);
%	[Newpop,Newfit]=selsort(Oldpop,Oldfit,Num);
%
%	       Newpop - new selected population
%	       Newfit - fitness vector of Newpop
%	       Oldpop - old population
%	       Oldfit - fitness vector of Oldpop
%	       Num    - number of the selected strings 
%

% I.Sekaj, 12/1998

function[Newpop,Newfit]=selsort(Pop,Fvpop,N)


[fit,nix]=sort(Fvpop);

for j=1:N
 Newpop(j,:)=Pop(nix(j),:);
end;
Newfit=fit(1:N);