function wbs = generateWBs(netLayout)
%GENERATEWBS Summary of this function goes here
%   Detailed explanation goes here
    wbCount = calculateWBCount(netLayout);    
    % generate random num between -1 and 1
    wbs = 2*rand(wbCount, 1) - 1;
end

