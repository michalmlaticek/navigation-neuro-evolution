function wbs = generateWBs(netLayout)
%GENERATEWBS Summary of this function goes here
%   Detailed explanation goes here
    wbCount = 0;
    for i = 1 : length(netLayout) - 1
        wbCount = wbCount + ((netLayout(i) + 1)*netLayout(i+1));
    end % for i
    
    wbs = rand(wbCount, 1);
end

