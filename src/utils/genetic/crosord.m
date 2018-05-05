% CROSORD - crossover of permutation type string
%
% Vytvori novu populaciu retazcov ktora vznikne skrizenim vsetkych 
% retazcov starej populacie 2-bodovym krizenim permutacneho typu. 
% Krizene su vsetky retazce (ak je ich parny pocet).
%
% Pouzitie:  Newpop=crosord(Oldpop,sel)
%
%            Oldpop - stara populacia
%            sel - sposob vyberu dvojic: 0 - nahodny, 1 - susedne dvojice v populacii 
%
% I.Sekaj, 8/2001

function[Newpop]=crosord(Oldpop,sel)

[lpop,lstring]=size(Oldpop);
Newpop=Oldpop;
flag=zeros(1,lpop);
num=fix(lpop/2);
i=1;

for cyk=1:num	% vytvaranie dvojic retazcov s indexami i a j

if sel==0     % nahodne parovanie retazcov

while flag(i)~=0
 i=i+1;
end;
flag(i)=1;
j=ceil(lpop*rand);
while flag(j)~=0
  j=ceil(lpop*rand);
end;
flag(j)=2; 

elseif sel==1   % parovanie susednych retazcov

i=2*cyk-1;
j=i+1;

end;

p1=ceil(0.0001+rand*(lstring-2));	% pozicie delenia retazca p1, p2
p2=ceil(0.0001+rand*(lstring-p1))+p1;
if p2>lstring p2=lstring; end;
if p1==1 & p2>=(lstring-1) p2=lstring-2; end;
if p1==2 & p2>=lstring p2=lstring-1; end;

Newpop(i,(p1:p2))=Oldpop(i,(p1:p2));
Newpop(j,(p1:p2))=Oldpop(j,(p1:p2));
nxch=lstring-(p2-p1+1);

pos=1; all=0; 
while all==0
  for k2=1:lstring
  if pos==p1 pos=p2+1; end;
    nasiel=0;
    for k1=p1:p2
      if Oldpop(i,k1)==Oldpop(j,k2)
        nasiel=1;
      end;
    end;
    if nasiel==0 
      Newpop(i,pos)=Oldpop(j,k2);
      pos=pos+1;
      if pos>=nxch+1 all=1; end;
    end;
  end;   
end;

pos=1; all=0; 
while all==0
  for k2=1:lstring
  if pos==p1 pos=p2+1; end;
    nasiel=0;
    for k1=p1:p2
      if Oldpop(j,k1)==Oldpop(i,k2)
        nasiel=1;
      end;
    end;
    if nasiel==0 
      Newpop(j,pos)=Oldpop(i,k2);
      pos=pos+1;
      if pos>=nxch+1 all=1; end;
    end;
  end;   
end;

end; % cyk

