classdef MapFactory
    %MAP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods(Static)        
        function plane = basic_map(width, height, obst_w, obst_h, border_width)
            plane = uint8(ones(height, width));
            mid_w = uint8(width / 2);
            mid_h = uint8(height / 2);
            obst_w = uint8(obst_w / 2);
            obst_h = uint8(obst_h / 2);
            plane(mid_h-obst_h:mid_h+obst_h, mid_w-obst_w:mid_w+obst_w) = 0;
            plane(:, 1:border_width) = 0; 
            plane(1:border_width,:) = 0; 
            plane(:, width-border_width:width) = 0; 
            plane(height-border_width:height, :) = 0;
        end
    end
end

