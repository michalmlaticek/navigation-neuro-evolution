% swappart- exchange of the order of two substrings in the strings
%
%	Description:
%	The function exchanges the order of two substrings, which will arise after 
%	spliting a string in two parts. The number of such modificated strings in
%	the population depends on the parameter rate.
%
%
%	Syntax: 
%
%	Newpop=swappart(Oldpop,rate)
%
%	       Newpop - new modificated population
%	       Oldpop - old population
%	       rate   - mutation intensity, 0 =< rate =< 1
%

% I.Sekaj, 2/2001

function[Newpop]=swappart(Oldpop,factor)

[lpop,lstring]=size(Oldpop);

if factor>1 factor=1; end;
if factor<0 factor=0; end;

n=ceil(lpop*factor*rand);

Newpop=Oldpop;

for i=1:n
r=ceil(rand*lpop);
s=ceil(rand*lstring);

Newpop(r,:)=[Oldpop(r,s:lstring),Oldpop(r,1:(s-1))];

end;

