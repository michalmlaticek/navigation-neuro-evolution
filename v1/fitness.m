function value = fitness(weights, net, robot, world, start, target, stepSize, stepCount)
% 1. set net weights
% 2. loop
%   2.1 get scan values
%   2.2 calculate distance
%   2.3 calculate angle error
%   2.2 run network
%   2.3 reposition robot
%   2.4 if new position is wall - increase counter
%   2.5 log position
    
    %init
    net = setwb(net, weights); % set weights
    robotPosition = start;
    mapRobot = world.addRobot(robot, start);
    scanCoordinates = robot.scanCoordinates();
    
    %log params
    angles = [];
    
    % visualize
    world.draw();
    
    for i = 1:stepCount
        scan = world.getArea(scanCoordinates + robotPosition);
        % shift target coordinates to [0,0]
        relativeTarget = target-robotPosition;
        distance2Target = sqrt(sum(relativeTarget.^2));
        angle2Target = (atan(relativeTarget(2)/relativeTarget(1)) - atan(robot.nose(2)/robot.nose(1)));
        netInput = [scan; distance2Target; angle2Target];
        
        robotAngle = net(netInput);
        
        dXY = round([cos(robotAngle); sin(robotAngle)]*stepSize);
        robotPosition = robotPosition + dXY; % calc new position based on angle
        %rotate scan coordinates
        scanCoordinates = round([cos(robotAngle) -sin(robotAngle); ...
                sin(robotAngle) cos(robotAngle)]*scanCoordinates);
        
        
        
        % log    
        angles = [angles; robotAngle];
        
        % visualize
        mapRobot.move(dXY);
        world.draw();
    end % for i  
    
    
    %save("angles", angles);
end

