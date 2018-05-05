% Test function 9 (Griewank fun.)
% The global optimum is:  x(i)=0 ; i=1...n ;  Fit(x)=0 ;
% -600 < x(i) < 600


function[Fit]=testfn9(Pop)

[lpop,lstring]=size(Pop);

for i=1:lpop
  G=Pop(i,:);
  ff1=(1/4000)*sum(G.^2);
  ff2=1;
  for j=1:lstring
    ff2=ff2*(cos(G(j)/sqrt(j)));
  end;     
  Fit(i)=ff1-ff2+1;
end;
