This is the one that did not save population along. So there is no possibility to run simulation.
It uses tanh, however the output extraction was incorect. It didn't use the 0 for movement, when out2 < 0, so again it could never fully stop.


The fitness: 10*target_distances + 100*collisions + 0.001*path_lens + 0.001*rotations;
Population: 150

settings = {};
settings.netLayout = [9 3 2];
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