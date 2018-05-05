function isCollision = isCollision(mapRobot, map)
    isCollision = false;
    mapRobotArea = mapRobot.getRobotBody();
    for i = 1:length(mapRobotArea)
        if map(mapRobotArea(1, i), mapRobotArea(2, i)) == 0 % if obstacle
            isCollision = true;
            break;
        end % if
    end % for i
end