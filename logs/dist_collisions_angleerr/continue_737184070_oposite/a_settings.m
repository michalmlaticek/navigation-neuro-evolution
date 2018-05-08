function settings = a_settings()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Experriment Settings
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    settings = {};
    settings.netLayout = [9 3 2];
    settings.initPosition = reshape([210;210], [1, 1, 2]);
    settings.targetPosition = reshape([40;40], [1, 1, 2]);
    settings.radius = 10;
    settings.sensorAngles = [-60; -40; -20; 0; 20; 40; 60];
    settings.sensorLen = 40;
    settings.maxSpeed = 10;
    settings.initAngle = 0;
    settings.duration = 1; %duration between scans

    settings.gen_count = 2500;
    settings.pop_count = 150;
    settings.step_count = 1000; % number of steps the agent is executing

    settings.cmap = create_cmap(settings.pop_count);
    %settings.map = MapFactory.basic_map(250, 250, 20, 50, 3);
    settings.map = MapFactory.from_img('../../../maps/map_4_path_2.png');
    settings.max_distance = sqrt(size(settings.map, 1)^2 + size(settings.map, 2)^2);
    settings.robot = Robot(settings.radius, settings.sensorAngles, ...
        settings.sensorLen, settings.maxSpeed, []);
    body = get_body(settings.radius)';
    settings.body = reshape(body, [length(body), 1, 2]);
    settings.M = 1;
end

