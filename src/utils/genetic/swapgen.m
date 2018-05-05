% swapgen - mutation of the gene-order in strings
%
%
%	Description:
%	The function exchanges (mutates) the order of some random selected genes
%	in random selected strings in the population. The mutation intensity depends
%	on the parameter rate.
%
%
%	Syntax: 
%
%	Newpop=swapgen(Oldpop,rate)
%
%	       Newpop - new mutated population
%	       Oldpop - old population
%	       rate   - mutation intensity, 0 =< rate =< 1
%

% I.Sekaj, 2/2001

function[Newpop]=swapgen(Oldpop,factor)

[lpop,lstring]=size(Oldpop);

if factor>1 factor=1; end;
if factor<0 factor=0; end;

n=ceil(lpop*lstring*factor*rand);

Newpop=Oldpop;

for i=1:n
r=ceil(rand*lpop);
s1=ceil(rand*lstring);
s2=ceil(rand*lstring);
if s1==s2 s2=ceil(rand*lstring); end;

str=Newpop(r,s1);
Newpop(r,s1)=Newpop(r,s2);
Newpop(r,s2)=str;

end;

