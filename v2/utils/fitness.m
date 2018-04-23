function fit = fitness(weights, map, robot, target, duration, stepCount)
    global draw
    global draw_refresh_rate

    localRobot = MapRobot(robot.id, robot.angle, robot.position, robot.radius, ...
        robot.sensorAnglesDeg, robot.sensorLen, robot.maxSpeed, robot.neuralNet, robot.target);
   
    
    world = World(map, localRobot);
    if draw
        world.draw(target);
    end
    
    localRobot.setWBs(weights);
    %steps = zeros(stepCount, 2);
    i = 1;
    IsCollision = false;
    IsTarget = false;
    collision_counter = 0;
    for i = 1:stepCount 
        step = localRobot.step(map, duration);
        %steps = [steps; step];
        
        if draw
            world.draw(target);
            pause(draw_refresh_rate);
        end
        IsCollision = isCollision(localRobot, map);
        IsTarget = isequal(target, localRobot.positionRounded);
        if  IsCollision
            collision_counter = collision_counter + 1;
        end
        
        if IsTarget
           break; 
        end
    end
    
    %if IsCollision
    %    alfa = 2;
    %else
    %    alfa = 1;
    %end
    
    %if IsTarget
    %    beta = 0;
    %else
    %    beta = 1;
    %end
    
    %fit = alfa*beta*(abs(localRobot.angleErrNorm) + abs(localRobot.distErrNorm));
    fit = collision_counter + localRobot.distErr;
end

