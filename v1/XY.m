classdef XY
    %COORDINATES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        X % x coordinate
        Y % y coordinate
    end
    
    methods
        function obj = XY(x, y)
            obj.X = x;
            obj.Y = y;
        end
    end
end

