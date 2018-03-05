classdef Robot < handle
    %ROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nose % local nose position % reflects rotation
        meR % robot will be represented as a circle
        scanR
        me
        scan
    end
    
    methods
        function robot = Robot(robotR, scanR, initialRotationDeg)
            robot.nose = [robotR;0];
            robot.meR = robotR;
            robot.scanR = scanR;        
            robot.rotateDeg(initialRotationDeg);
            robot.me = robot.myCoordinates();
            robot.scan = robot.scanCoordinates();
        end
        
        function nose = rotateDeg(robot, theta)
            nose = robot.rotate(theta*pi/180);
        end % function
        
        function nose = rotate(robot, theta)
           R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
           robot.nose = round(R*robot.nose);
           nose = robot.nose;
        end % function
        
        function me = myCoordinates(robot)
            me = [];
            for i = -robot.meR:robot.meR
                for j = -robot.meR:robot.meR
                    if i^2+j^2 <= robot.meR^2 % is inside robot circle?
                        me = [me, [i; j]];
                    end
                end % for - j
            end % for - i
        end % function
        
        function scan = scanCoordinates(robot)
            scan = [];
            for i = -robot.scanR:robot.scanR
                for j = -robot.scanR:robot.scanR
                    c = i^2+j^2;
                    if c <= (robot.scanR^2) && c > (robot.meR^2) % is inside scan circle and outside robot circle
                        scan = [scan, [i; j]];
                    end
                end % for - j
            end % for - i
        end % function
        
        function readings = parseScan(robot, scanArea)
            dAngle = atan2(robot.nose(2), robot.nose(1));
            readings = [];
            for i = 1:lenght(scanArea)
                if scanArea(i) > 1
                    readings = [atan2(robot.scan(2, i), robot.scan(1, i)) + dAngle; ...
                        sqrt(robot.scan(1, i)^2 + robot.scan(2, i)^2)];
                end % if
            end % for
        end % function        
    end
    
%     methods (Abstract)
%        next 
%     end
end