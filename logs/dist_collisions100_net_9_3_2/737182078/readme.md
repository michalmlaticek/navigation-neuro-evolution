Again, the charts seem inconsistent with simulation where it's clearly seen that there are some collisions, however
the chart says otherwise

num of generations calculated: 1500

fitness: should be ... dist + 100*collision


Activation func: seems to be _/- (eval_nets)

function settings = a_settings()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Experriment Settings
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    settings = {};
    settings.netLayout = [9 3 2];
    settings.genom_len = calculateWBCount(settings.netLayout);
    init_positions = [40 40];
    target_positions = [210 210];
    settings.initPosition = reshape(init_positions, [1, size(init_positions, 1), 2]);
    settings.targetPosition = reshape(target_positions, [1, size(target_positions, 1), 2]);
    settings.radius = 15;
    settings.sensorAngles = [-60; -40; -20; 0; 20; 40; 60];
    settings.sensorLen = 40;
    settings.maxSpeed = 15;
    settings.initAngle = 0;
    settings.duration = 1; %duration between scans

    settings.gen_count = 1500;
    settings.pop_count = 100;
    settings.step_count = 300; % number of steps the agent is executing

    settings.cmap = create_cmap(settings.pop_count);
    %settings.map = MapFactory.basic_map(250, 250, 20, 50, 3);
    settings.map = MapFactory.from_img('../../../maps/map_4_path_2.png');
    settings.max_distance = sqrt(size(settings.map, 1)^2 + size(settings.map, 2)^2);
    settings.robot = Robot(settings.radius, settings.sensorAngles, ...
        settings.sensorLen, settings.maxSpeed, []);
    body = get_body(settings.radius)';
    settings.body = reshape(body, [length(body), 1, 2]);
    settings.M = 2;
    settings.space=[-settings.M*ones(1,settings.genom_len); settings.M*ones(1,settings.genom_len)];  % working space
    settings.sigma=settings.space(2,:)/50; %mutation working space
end
