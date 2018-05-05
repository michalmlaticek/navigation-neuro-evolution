function net_outs = eval_nets_tanh(nets,pop_ins)
    % pop_ins (input_layer_size, pop_size)
    pop_size = size(pop_ins, 2);
    outs = pop_ins;
    for l = 1:(size(nets, 2)-1)
        ins = outs;
        outs = zeros(size(nets{l}.W, 1), pop_size);
        for p = 1:pop_size
            outs(:, p) = tanh((nets{l}.W(:, :, p) * ins(:, p)) + nets{l}.b(:, p));
        end        
    end
    
    % different activation for output layer
    net_outs = zeros(2, pop_size);
    for p = 1:pop_size
        net_outs(:, p) = tanh((nets{end}.W(:, :, p) * outs(:, p)) + nets{end}.b(:, p));
    end        
end



