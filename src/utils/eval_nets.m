function net_outs = eval_nets(nets,pop_ins)
    % pop_ins (input_layer_size, pop_size)
    pop_size = size(pop_ins, 2);
    outs = pop_ins;
    for l = 1:(size(nets, 2)-1)
        ins = outs;
        outs = zeros(size(nets{l}.W, 1), pop_size);
        for p = 1:pop_size
            outs(:, p) = clamped((nets{l}.W(:, :, p) * ins(:, p)) + nets{l}.b(:, p));
        end        
    end
    
    % different activation for output layer
    net_outs = zeros(2, pop_size);
    for p = 1:pop_size
        net_outs(:, p) = clamped((nets{end}.W(:, :, p) * outs(:, p)) + nets{end}.b(:, p));
    end        
end

function n = clamped(n)
    minus_one_idx = n < -1.0;
    n(minus_one_idx) = 0;
    one_idx = n > 1.0;
    n(one_idx) = 1;
end

function a = hardlogsig(n)
%LOGSIG.APPLY Apply transfer function to inputs

% Copyright 2012-2015 The MathWorks, Inc.
  a = 1 ./ (1 + exp(-n));
  
  zero_idx = a < 0.01;
  a(zero_idx) = 0;
  one_idx = a > 0.99;
  a(one_idx) = 1;
end



