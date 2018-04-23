% Test function 6 (Search for the in string H defined combination of 8 integer numbers)
% 0<x<10, Fit(opt)=0, (Fit -> number of incorrect integers)

function[Fit]=testfn6(Pop)
eps=0.05;			% tlolerance 
H=[0 1 2 3 4 5 6 7];		% solution

[lpop,lstring]=size(Pop);

for i=1:lpop
  G=Pop(i,:);
  Fit(i)=lstring;
  for j=1:lstring
    if abs(G(j)-H(j))<eps 
      Fit(i)=Fit(i)-1; 
    end; 
  end;     
end;
