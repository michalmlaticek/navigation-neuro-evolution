classdef Obstacle
    %OBSTACLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Corners
    end
    
    methods
        % constructor
        function obj = Obstacle(corners)
            obj.Corners = corners;
        end
        function [OX, OY] = connect(obj)
            OX = [];
            OY = [];
            for i = 1:(length(obj.Corners)-1)
                [X, Y] = obj.getLinePoints(i, i+1);
                OX = [OX; X];
                OY = [OY; Y];
            end
            
            % add connection from last point to first
            [X, Y] = obj.getLinePoints(length(obj.Corners), 1);
            OX = [OX; X];
            OY = [OY; Y];            
        end
        
        function [X, Y] = getLinePoints(obj, i1, i2)
            % calculate the distance between two points
            x1 = obj.Corners(i1).X;
            x2 = obj.Corners(i2).X;
            y1 = obj.Corners(i1).Y;
            y2 = obj.Corners(i2).Y;                
                
            [X, Y] = bresenham(x1,y1,x2,y2);
        end
    end
end
    
