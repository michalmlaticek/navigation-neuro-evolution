% INVORD - inversion of order of a substring
%
% V nahodne vybranych retazcoch populacie invertuje poradie genov
% vzdy jedneho nahodne vybraneho subretazca 
%
% Pouzitie:  Newpop=invord(Oldpop,rate)
%
%            Oldpop - stara populacia
%            rate - pocetnost vyskytu modifikovanych retazcov v populacii (0;1) 
%
% I.Sekaj, 8/2001

function[Newpop]=invord(Oldpop,rate)

[lpop,lstring]=size(Oldpop);

if rate>1 rate=1; end;
if rate<0 rate=0; end;

n=ceil(lpop*rate*rand);

Newpop=Oldpop;

for i=1:n

r=ceil(rand*lpop);		% vybrany retazec
p1=ceil(0.001+rand*(lstring-1));	% pozicie delenia retazca p1, p2
p2=ceil(0.001+rand*(lstring-p1))+p1;
if p1==lstring p1=lstring-1; end;
if p2>lstring p2=lstring; end;

for j=p1:p2
  k=p2-(j-p1);
  Newpop(r,j)=Oldpop(r,k);
end;
Oldpop=Newpop;

end;	% n