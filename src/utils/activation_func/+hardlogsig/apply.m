function a = apply(n,param)
%LOGSIG.APPLY Apply transfer function to inputs

% Copyright 2012-2015 The MathWorks, Inc.
  a = 1 ./ (1 + exp(-n));
  
  zero_idx = a < 0.01;
  a(zero_idx) = 0;
  one_idx = a > 0.99;
  a(one_idx) = 1;
end


