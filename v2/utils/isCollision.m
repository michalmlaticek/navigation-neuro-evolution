function isCollision = isCollision(mapRobot, map)
    isCollision = false;
    body = mapRobot.getRobotBody();
    for i = 1:length(body)
        if body(1, i) < 1 || ...
                body(2, i) < 1 || ...
                body(1, i) > size(map, 1) || ...
                body(2, i) > size(map, 2) || ...
                map(body(1, i), body(2, i)) == 0 % if obstacle
            isCollision = true;
            break;
        end % if
    end % for i
end