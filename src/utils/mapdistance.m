function dist = mapdistance(source,target)
    %DISTANCE Summary of this function goes here
    %   Detailed explanation goes here
    dist = sqrt(sum((target - source).^2));
end

