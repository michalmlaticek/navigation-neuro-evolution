function settings = a_settings()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Experriment Settings
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    settings = {};
    settings.netLayout = [10 6 2];
    settings.genom_len = calculateWBCount(settings.netLayout);
    init_positions = [23 23; 220 30];
    target_positions = [220 30; 25 225];
    settings.initPosition = reshape(init_positions, [1, size(init_positions, 2), 2]);
    settings.targetPosition = reshape(target_positions, [1, size(target_positions, 2), 2]);
    settings.radius = 10;
    settings.sensorAngles = [-60; -40; -20; 0; 20; 40; 60];
    settings.sensorLen = 40;
    settings.maxSpeed = 15;
    settings.initAngle = 0;
    settings.duration = 1; %duration between scans

    settings.gen_count = 2000;
    settings.pop_count = 150;
    settings.step_count = 1200; % number of steps the agent is executing

    settings.cmap = create_cmap(settings.pop_count);
    %settings.map = MapFactory.basic_map(250, 250, 20, 50, 3);
    settings.map = MapFactory.from_img('../../../maps/map_73_path_2_flip.png');
    settings.max_distance = sqrt(size(settings.map, 1)^2 + size(settings.map, 2)^2);
    settings.robot = Robot(settings.radius, settings.sensorAngles, ...
        settings.sensorLen, settings.maxSpeed, []);
    body = get_body(settings.radius)';
    settings.body = reshape(body, [length(body), 1, 2]);
    settings.M = 1;
    settings.space=[-settings.M*ones(1,settings.genom_len); settings.M*ones(1,settings.genom_len)];  % working space
    settings.sigma=settings.space(2,:)/50; %mutation working space
end

