classdef MapRobot < Robot
    %MAPROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id
        position
        positionRounded
        angleDeg
        angle
        
        body
        
        target
        
        angleErrNorm
        distErrNorm
    end
    
    methods
        function robot = MapRobot(id,angle,position,radius,sensorAngles,...
                sensorLength, maxSpeed, neuralNet, target)
            robot@Robot(radius, sensorAngles, sensorLength, maxSpeed, neuralNet);
            robot.id = id;
            robot.angleDeg = angle;
            robot.angle = angle * pi / 180;
            robot.position = position;
            robot.positionRounded = round(position);
            %robot.robotArea = getmidpointcircle(radius);
            robot.body = robot.constructRelativeBody(radius);
            
            robot.target = target;
            % for now let's do static map size
%             robot.distErrNorm = robot.getTargetDistance(target)/sqrt(sum(size(map).^2));
            robot.distErrNorm = robot.getTargetDistance(target)/223.4457;
            robot.angleErrNorm = robot.getAngleError(target)/(2*pi);
        end
        
        function step = step(robot, map, duration)
            sensorLines = robot.getSensorLines();
            sensorReadings = robot.getSensorReadings(sensorLines, map);
            sensorReadingsNorm = sensorReadings./robot.sensorLen;
            nav = robot.navigate(sensorReadingsNorm, robot.distErrNorm, robot.angleErrNorm);
            dAngle = nav(1);
            speed = nav(2);
            robot.angle = robot.angle + dAngle;
            if robot.angle > 2*pi
                robot.angle = robot.angle - 2*pi;
            end
            robot.angleErrNorm = robot.getAngleError(robot.target)/(2*pi);
            robot.distErrNorm = robot.getTargetDistance(robot.target)/223.4457;
            
            %angle = mapRobot.angle
            %position = mapRobot.position
            traveledDistance = speed * duration;
            dPosition = anglec2dxy(robot.angle, traveledDistance);
            robot.position = robot.position + dPosition;
            robot.positionRounded = round(robot.position);
            step = [dAngle, speed];
        end
        
        function step = stepTest(robot, map, target, duration, dAngleDeg, speed)
            sensorLines = robot.getSensorLines();
            sensorReadings = robot.getSensorReadings(sensorLines, map);
            robot.angleError = robot.getAngleError(target);
            robot.distError = robot.getTargetDistance(target);
            %[dAngle, speed] = mapRobot.navigate(sensorReadings, targetDistance, angleError);
            % the only difference is, that we are providedin required
            % dAngle and speed values, rather than relying on NN
            % for test purpose only
            robot.angle = robot.angle + (dAngleDeg*pi/180);
            robot.angleDeg = robot.angle*180/pi;
            traveledDistance = speed * duration;
            dPosition = anglec2dxy(robot.angle, traveledDistance);
            robot.position = robot.position + dPosition;
            robot.positionRounded = round(robot.position);
            step = struct( ...
                'dangle', dAngleDeg*pi/180, ...
                'dangleDeg', dAngleDeg, ...
                'speed', speed, ...
                'angle', robot.angle, ...
                'angleDeg', robot.angleDeg, ...
                'positionX', robot.position(1), ...
                'positionY', robot.position(2), ...
                'discretePositionX', robot.positionRounded(1), ...
                'discretePositionY', robot.positionRounded(2), ...
                'sensorReadings', sensorReadings, ...
                'angleError', robot.angleError, ...
                'targetDistance', robot.distError ...
                );
        end
        
        function robotBody = getRobotBody(mapRobot)
           robotBody = mapRobot.body + mapRobot.positionRounded; 
        end
        
        function sensorLines = getSensorLines(mapRobot)
            sensorLines = {};
           % for each sensor
            for i = 1:length(mapRobot.sensorAngles)
                % get angle
                sensorAngle = mapRobot.sensorAngles(i)+mapRobot.angle;
                % get sensor coordinates
                sensorCoordinates = mapRobot.getSensorCoordinates(sensorAngle);
                sensorLines{end + 1} = sensorCoordinates;
            end
        end
    end
    
    methods (Access = private)
        function body = constructRelativeBody(robot, radius) 
            body = [];
            for i = -radius:radius
                for j = -radius:radius
                    if i^2+j^2 <= radius^2 % is inside robot circle?
                        body = [body, [i; j]];
                    end
                end % for - j
            end % for - i
        end
        
        function sensorReadings = getSensorReadings(mapRobot, sensorLines, map)
            sensorReadings = [];
            for i = 1:length(sensorLines)
                sensorCoordinates = sensorLines{i};
                sensorReading = mapRobot.readSensor(sensorCoordinates, map);
                sensorReadings = [sensorReadings; sensorReading];                
            end
        end
        
        function sensorCoordinates = getSensorCoordinates(mapRobot, angle)
            % get end point coordinates
            sensorEnd = anglec2dxy(angle, mapRobot.sensorLen) + mapRobot.position;
            % make discrete (round)
            sensorEnd = round(sensorEnd);
            %build line coordinates
            sensorCoordinates = bresenham(mapRobot.positionRounded, sensorEnd);                
        end
            
        function sensorReading = readSensor(mapRobot, sensorCoordinates, map)
            sensorReading = 2*mapRobot.sensorLen;
            for i = 1:length(sensorCoordinates)
               if map(sensorCoordinates(1, i), sensorCoordinates(2, i)) == 0
                    sensorReading = mapdistance(mapRobot.position, sensorCoordinates(:, i));
                    break;
               end % if
            end % for i
        end
        
        function angleError = getAngleError(mapRobot, target)
            relativeTarget = target - mapRobot.position;
            targetAngle = atan(relativeTarget(2)/relativeTarget(1));
            angleError = targetAngle - mapRobot.angle;
        end
        
        function targetDistance = getTargetDistance(mapRobot, target)
           targetDistance = mapdistance(mapRobot.position, target); 
        end
    end
end

