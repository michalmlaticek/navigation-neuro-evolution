% Quadratic objective function, unimodal optimisation problem
% X(opt)=[0 0 0 ... 0]; Fit(opt)=0;
% -10<x<10; 

function[Fit]=testfn1(Pop)

[lpop,lstring]=size(Pop);

for i=1:lpop
  G=Pop(i,:);
  Fit(i)=0;	
  for j=1:lstring
    Fit(i)=Fit(i)+G(j)*G(j);    
  end;     
end;
