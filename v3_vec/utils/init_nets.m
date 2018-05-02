function layers = init_nets(layout, weights)
    % It constructs network layers in the same fassion as toolbox
    pop_size = size(weights, 2);
    layers = cell(1, size(layout, 2)- 1);
    s = 1;
    for l = 1: (size(layout, 2) -1)
        layers{l}.W = zeros(layout(l+1), layout(l), pop_size);
        e = s + layout(l+1) - 1;
        layers{l}.b = weights(s:e, :);
        for n = 1:layout(l)
            s = e + 1;
            e = s + layout(l+1)-1;
            layers{l}.W(:, n, :) = weights(s:e, :);
            s = e + 1;
        end
    end
end

