classdef World < handle    
    properties
        map
        cmap
        robots
        obstacleValue
        robotBodyValue
        robotSensorValue
        freeSpaceValue
        targetValue
    end
    
    methods
        function world = World(map, robots)
            world.map = map;
            world.cmap = [
                0 0 0; ... % obstacle color
                1 1 1; ... % free color
                220/255 220/255 200/255; ... % robot color
                30/255 144/255 255/255; ...  % robot direction line color
                1 0 0 ... % target
                ]; 
            world.obstacleValue = 0;
            world.freeSpaceValue = 1;
            world.robotBodyValue = 2;
            world.robotSensorValue = 3;
            world.targetValue = 4;
            
            world.robots = robots;
        end
        
        function addObstacle(world, indexes)
            % directly writing to map matrxix because they are not going to
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
                map(robotBody(1,i),robotBody(2, i)) = world.robotBodyValue;
            end %for
            
            sensorLines = mapRobot.getSensorLines();
            for i = 1:length(sensorLines)
                sensorLine = sensorLines{i};
                for j = 1:length(sensorLine)
                    map(sensorLine(1, j), sensorLine(2, j)) = world.robotSensorValue;
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

