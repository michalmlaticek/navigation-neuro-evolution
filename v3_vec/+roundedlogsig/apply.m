function a = apply(n,param)
%LOGSIG.APPLY Apply transfer function to inputs

% Copyright 2012-2015 The MathWorks, Inc.

  a = round(1 ./ (1 + exp(-n)), 4);
end


