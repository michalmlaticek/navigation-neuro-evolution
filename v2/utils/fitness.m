function fit = fitness(weights, map, robot, target, duration, stepCount, draw)
    localRobot = MapRobot(robot.id, robot.angle, robot.position, robot.radius, ...
        robot.sensorAnglesDeg, robot.sensorLen, robot.maxSpeed, robot.neuralNet, robot.target);
   
    if draw
        world = World(map, localRobot);
        world.draw(target);
    end
    
    localRobot.setWBs(weights);
    %steps = zeros(stepCount, 2);
    i = 1;
    IsCollision = false;
    IsTarget = false;
    while i < stepCount 
        step = localRobot.step(map, duration);
        %steps = [steps; step];
        
        if draw
            world.draw(target);
            pause(0.2);
        end
        IsCollision = isCollision(localRobot, map);
        IsTarget = isequal(target, localRobot.positionRounded);
        if  IsCollision || IsTarget
            break;
        end
        
        i = i + 1;
    end
    
    if IsCollision
        alfa = 2;
    else
        alfa = 1;
    end
    
    if IsTarget
        beta = 0;
    else
        beta = 1;
    end
    
    fit = alfa*beta*(abs(localRobot.angleErrNorm) + abs(localRobot.distErrNorm));
end

