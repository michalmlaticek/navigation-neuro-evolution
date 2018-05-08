This is an experiment that started with agent evolved to go from A to B. Now we switched the points and continued evolution to go from B to A


When simulated on a new target point with coordinates: [40, 195] ....

with tanh they collided and got completely stuck. When clamped, than there were some collisions, but some of the agents managed to pull trough.


When simulated again on configuration A to B ([40, 40], [210, 210]) ...
Some collided and got stuck, some collided but pulled through and found the target. However, it rather seems, that they have evolved to follow a path, rather than react to the env.

probably too few obstacles.
 

Fitness: 10*distances + 100*collisions + 0.001*combined_angle_errs; (increases collision weight from 10 to 100)

Activation: clamped


gen start: 2026
gen end: 4527







function settings = a_settings()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Experriment Settings
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    settings = {};
    settings.netLayout = [9 3 2];
    settings.genom_len = calculateWBCount(settings.netLayout);
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
    settings.space=[-settings.M*ones(1,settings.genom_len); settings.M*ones(1,settings.genom_len)];  % working space
    settings.sigma=settings.space(2,:)/50; %mutation working space
end

