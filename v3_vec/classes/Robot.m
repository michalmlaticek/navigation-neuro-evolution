classdef Robot < handle
    %ROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius % robot radius (considering a circle robot)
        sensorAnglesDeg % array of sensor angles in degrees
        sensorAngles % array of sensor angles in radians 
        sensorLen % length to which a sensor can see
        neuralNet % neural network that serves as a controller
        maxSpeed
%         angleErrNorm
%         distErrNorm
    end
    
    methods
        function robot = Robot(radius, sensorAngles, sensorLength, maxSpeed, neuralNet)
            robot.radius = radius;
            robot.sensorAnglesDeg = sensorAngles;
            robot.sensorAngles = sensorAngles * pi/180;
            robot.sensorLen = sensorLength;        
            robot.neuralNet = neuralNet;
            robot.maxSpeed = maxSpeed;
        end
        
        function nav = navigate(robot, sensorReadings, distance, angleError)           
           input = [sensorReadings; distance; angleError];
           nav = robot.neuralNet(input);
           
           nav = [nav(1)*2*pi; nav(2)*robot.maxSpeed];
        end
        
%         function nav = navigate(robot, sensorReadings, distance, angleError, map)
%             sensorReadings = sensorReadings./robot.sensorLen;
%             distance = distance/sqrt(sum(size(map).^2));
%             angleError = angleError/(2*pi);
%             
%             input = [sensorReadings; distance; angleError];
%             nav = robot.neuralNet(input);
%             
%             nav = [nav(1)*2*pi; 10];
%         end
        
        function setWBs(robot, wbs)
            robot.neuralNet = setwb(robot.neuralNet, wbs); % set weights
        end
    end
end