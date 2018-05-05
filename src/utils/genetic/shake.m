% shake - random shaking of the string order in the population
%
%	Description: 
%	The function returns a population with random changed order of strings. 
%	The strings are without any changes. The intensity of shaking depends on the 
%	parameter rate.
%
%
%	Syntax: 
%
%	Newpop=shake(Oldpop,rate);
%
%	       Newpop - new population with changed string order
%	       Oldpop - old population
%	       rate   - shaking intensity from 0 to 1
%

% I.Sekaj, 12/1998

function[Newpop]=shake(Oldpop,MR)

[lpop,lchrom]=size(Oldpop);
if MR<0, MR=0; end;
if MR>1, MR=1; end;

Newpop=Oldpop;
Hlp=Oldpop;
n=lpop*MR;

for i=1:n
  ch1=0; ch2=0;
  while ch1==ch2
    ch1=ceil(rand*lpop);
    ch2=ceil(rand*lpop);
  end;
  Newpop(ch1,:)=Hlp(ch2,:);
  Newpop(ch2,:)=Hlp(ch1,:);
  Hlp(ch1,:)=Newpop(ch1,:);
  Hlp(ch2,:)=Newpop(ch2,:);
end;


