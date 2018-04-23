classdef World < handle    
    properties
        map
        cmap
        robots
        obstacleValue
        freeSpaceValue
        startValue
        targetValue
        robotColorValues
    end
    
    methods
        function world = World(map, robots)
            world.map = map;
            world.cmap = [
                0 0 0; ... % obstacle color
                1 1 1; ... % free color
                0 0 1; ... % start color
                1 0 0 ... % target                
                ];
            world.obstacleValue = 0;
            world.freeSpaceValue = 1;
            world.startValue = 2;
            world.targetValue = 3;
            
            world.robots = robots;
            
            world.robotColorValues = {};
            
            for i = 1: length(robots)
                r_color = [i i i] / 255;
                %s_color = [i i i] * 2 / 255;
               world.cmap = [world.cmap; r_color];
               world.robotColorValues{end+1}.body = i + 4;
               %world.robotSensorValue{end+1}.sensor = i + 5;
            end
            
            
        end
        
        function addObstacle(world, indexes)
            % directly writing to map matrix because they are not going to
            % move
            for i = 1:length(indexes)
                world.map(indexes(1,i),indexes(2,i)) = world.obstacleValue;
            end %for
        end %function - addObject
        
        function draw(world, target)
            map2Draw = world.map;
            map2Draw = world.drawAllRobots(map2Draw);
            map2Draw(target(1), target(2)) = world.targetValue;
            image(map2Draw, 'CDataMapping', 'direct');
            colormap(world.cmap);
            axis image
        end %function - draw
        
        function navProps = moveRobot(world, robotId, target, duration)
            navProps = world.robots{robotId}.step(world.map, target, duration);
        end
        
        function navProps = moveRobotTest(world, robotId, target, duration, dAngleDeg, speed)
            navProps = world.robots(robotId).stepTest(world.map, target, duration, dAngleDeg, speed);
        end
    end
       
    methods (Access = private)
        % private
        function map = drawRobot(world, map, mapRobot)
            robotBody = mapRobot.getRobotBody();
            for i = 1:length(robotBody)
                    if robotBody(1, i) > 0 && ...
                        robotBody(2, i) > 0 && ...
                        robotBody(1, i) < size(map, 1) && ...
                        robotBody(2, i) < size(map, 2)
                        map(robotBody(1,i),robotBody(2, i)) = world.robotColorValues{;
                    end
            end %for
            
            sensorLines = mapRobot.getSensorLines();
            for i = 1:length(sensorLines)
                sensorLine = sensorLines{i};
                for j = 1:length(sensorLine)
                    if sensorLine(1, j) > 0 && ...
                        sensorLine(2, j) > 0 && ...
                        sensorLine(1, j) < size(map, 1) && ...
                        sensorLine(2, j) < size(map, 2)
                        map(sensorLine(1, j), sensorLine(2, j)) = world.robotSensorValue;
                    end
                end %for j
            end %for i            
        end % function
        
        % private
        function mapWithRobots = drawAllRobots(world, map)
            for i = 1:length(world.robots)
                mapWithRobots = world.drawRobot(map, world.robots(i));
            end % for
        end % function
    end
end

