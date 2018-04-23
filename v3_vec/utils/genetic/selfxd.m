% selfxd - selection based on the diversity measure and fitness
%
%	Description:
%	The function selects from the input population a required number of strings
%	which combines the maximal distance from the reference string (or their affinity)  and fitness.
%
%
%	Syntax:
%
%	Newpop=selfxd(Oldpop,Oldfit,Nums,sw)
%   [Newpop,Newfit]=selfxd(Oldpop,Oldfit,Nums,sw)
%
%	       Newpop - new selected population
%	       Pop - old population
%	       Fit - vector of the objective function values of Oldpop
%          Newfit - vector of the objective function values of Newpop
%	       Nums   - number of selected individuals
%	       sw     - 0 = the reference string consists from genes which are 
%                       mean values of corresponding genes of the Oldpop 
%                   1 = the reference string is the best string forom Oldpop
%

% I.Sekaj, 1/2012

function[Newpop,Newfit]=selfxd(Pop,Fit,Nums,sw)

[lpop,lstring]=size(Pop);
if Nums>lpop Nums=lpop; end;

minfit=min(Fit);
maxfit=max(Fit);

if sw==1   
  str=selbest(Pop,Fit,1);
elseif sw==0	
  str=mean(Pop);
end;

for i=1:lpop	% Euclid. distance to reference string
  xx=0;
  for j=1:lstring
    xx=xx+(str(j)-Pop(i,j))^2;
  end;
  div(i)=sqrt(xx);
end;

mindiv=min(div);
maxdiv=max(div);

for i=1:lpop
    Nfit(i)=(Fit(i)-minfit)/(maxfit-minfit);    % normed fitness  <0,1>
    Ndiv(i)=(div(i)-mindiv)/(maxdiv-mindiv);    % normed distance <0,1>
    fxd(i)=sqrt(Nfit(i)^2+(1-Ndiv(i))^2);   % fitness x distance
end;

nn=ones(1,Nums);
[Newpop, Newfit]=selbest(Pop,fxd,nn);
