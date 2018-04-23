% Test function 8 (Rosenbrock fn.)
% The global optimum is:  x(i)=1 ; i=1...n ;  Fit(x)=0 ;
% -2 < x(i) < 2


function[Fit]=testfn8(Pop)

[lpop,lstring]=size(Pop);

for i=1:lpop
  G=Pop(i,:);
  Fit(i)=0;
  for j=1:(lstring)
    Fit(i)=Fit(i)+(100*(G(j)-G(j)^2)^2+(G(j)-1)^2);
  end;     
end;
