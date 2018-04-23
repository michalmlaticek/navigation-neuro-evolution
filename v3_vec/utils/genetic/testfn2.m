% Test function 2 (Rastigin's objective function)
% It is a multimodal function with optional number of input variables.
% The global optimum is:  x(i)=0; i=1...n ;  Fit(x)=0;
% -5 < x(i) < 5
% Other local minimas are located in a grid with the step=1

function[Fit]=testfn2(Pop)

[lpop,lstring]=size(Pop);

for i=1:lpop
  G=Pop(i,:);
  Fit(i)=lstring*10;	
  for j=1:lstring
    Fit(i)=Fit(i)+(G(j)^2-10*cos(2*pi*G(j)));
  end;     
end;
