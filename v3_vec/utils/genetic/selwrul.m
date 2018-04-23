% selwrul - rulette wheel selection
%
%
%	Description:
%	The function selects from the old population a required number of strings using
%	the "weighted roulette wheel selection". Under this selection method the individuals
%	have a direct-proportional probability to their fitness to be selected into the 
%	new population. 
%	
% 
%	Syntax:
%
%	Newpop=selwrul(Oldpop,Oldfit,Num);
%	[Newpop,Newfit]=selwrul(Oldpop,Oldfit,Num);
%
%	       Newpop - new selected population
%	       Newfit - fitness vector of Newpop
%	       Oldpop - old population
%	       Oldfit - fitness vector of Oldpop
%	       Num    - required number of selected strings
%

% I.Sekaj, 5/2000

function[Newpop,Newfit]=selwrul(Oldpop,Fvpop,n)

[lpop,lstring]=size(Oldpop);

sumfv=sum(Fvpop);

for i=1:lpop	
  if Fvpop(i)==0 Fvpop(i)=0.001; end
  men=Fvpop(i)*sumfv;
  if men==0 men=0.0000001; end;
  w0(i)=1/men;	% tvorba inverznych vah
end;
w0(i+1)=0;
w=zeros(1,lpop+1);
for i=lpop:-1:1	
  w(i)=w(i+1)+w0(i);
end;
maxw=max(w);
if maxw==0 maxw=0.00001;end;
w=(w/maxw)*100;		% vahovaci vektor

for i=1:n			% tocenie ruletou
  q=rand*100;
  for j=1:lpop
    if (q<w(j) & q>w(j+1)) break; end;
  end;
  Newpop(i,:)=Oldpop(j,:);
  Newfit(i)=Fvpop(j); 
end;
  