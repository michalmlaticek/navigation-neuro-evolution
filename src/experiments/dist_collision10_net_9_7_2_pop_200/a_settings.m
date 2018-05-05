function settings = a_settings()
    settings = {};
    settings.netLayout = [9 7 2];
    settings.initPosition = reshape([40;40], [1, 1, 2]);
    settings.targetPosition = reshape([210; 210], [1, 1, 2]);
    settings.radius = 15;
    settings.sensorAngles = [-60; -40; -20; 0; 20; 40; 60];
    settings.sensorLen = 40;
    settings.maxSpeed = 15;
    settings.initAngle = 0;
    settings.duration = 1;

    settings.step_count = 400;
    settings.gen_count = 2000;
    settings.pop_count = 200;

    settings.cmap = create_cmap(settings.pop_count);
    settings.map = MapFactory.from_img('../maps/map_4_path_2.png');
    settings.max_distance = sqrt(size(settings.map, 1)^2 + size(settings.map, 2)^2);
    settings.robot = Robot(settings.radius, settings.sensorAngles, ...
        settings.sensorLen, settings.maxSpeed, {});
    body = get_body(settings.radius)';
    settings.body = reshape(body, [length(body), 1, 2]);
    settings.M = 1;
end

