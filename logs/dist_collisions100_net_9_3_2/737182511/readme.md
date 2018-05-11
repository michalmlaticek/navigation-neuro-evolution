This seemed promissing and that the fitness was finally corectly set-up. Seems that this was the real reason that pushed for the increased step count, because the movement was
slow but had a good direction.

num of generation: 1500

fitness: fitnesses = distances + collisions*100;

activation func: _/- (eval_nets)

function settings = a_settings()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Evolution Settings
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    settings = {};
    settings.netLayout = [9 3 2];
    settings.genom_len = calculateWBCount(settings.netLayout);
    settings.initPosition = reshape([40;40], [1, 1, 2]);
    settings.targetPosition = reshape([210; 210], [1, 1, 2]);
    settings.radius = 15;
    settings.sensorAngles = [-60; -40; -20; 0; 20; 40; 60];
    settings.sensorLen = 40;
    settings.maxSpeed = 15;
    settings.initAngle = 0;
    settings.duration = 1;

    settings.step_count = 300;
    settings.gen_count = 1500;
    settings.pop_count = 100;

    settings.cmap = create_cmap(settings.pop_count);
    settings.map = MapFactory.from_img('../maps/map_4_path_2.png');
    settings.max_distance = sqrt(size(settings.map, 1)^2 + size(settings.map, 2)^2);

    settings.robot = Robot(settings.radius, settings.sensorAngles, ...
        settings.sensorLen, settings.maxSpeed, {});
    body = get_body(settings.radius)';
    settings.body = reshape(body, [length(body), 1, 2]);
    settings.M = 2;
    settings.space=[-settings.M*ones(1,settings.genom_len); settings.M*ones(1,settings.genom_len)];  % working space
    settings.sigma=settings.space(2,:)/50; %mutation working space
end

