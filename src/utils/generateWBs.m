function wbs = generateWBs(netLayout, pop_count)
%GENERATEWBS Summary of this function goes here
%   Detailed explanation goes here
    wbCount = calculateWBCount(netLayout);    
    % generate random num between -1 and 1
    wbs = 2*rand(wbCount, pop_count) - 1;
end

