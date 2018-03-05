function wbCount = calculateWBCount(netLayout)
    wbCount = 0;
    for i = 1 : length(netLayout) - 1
        wbCount = wbCount + ((netLayout(i) + 1)*netLayout(i+1));
    end % for i
end

