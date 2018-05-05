clc
clear

rng_id = round(now*1000);
run_id = sprintf('%9.0f', rng_id);

rng(rng_id)

global draw
global draw_refresh_rate
global logger

experiment = run_id;
draw = false;
draw_refresh_rate = 0.001;

log_folder = sprintf('logs/%s', experiment);
add_paths(log_folder);

logger = Logger(log_folder, 'simulation.log');
logger.debug(sprintf('Start of experiment: %s', experiment));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evolution Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
settings = {};
settings.netLayout = [9 3 2];
logger.debug('Net Layout: [9 3 2]');

settings.initPosition = reshape([40;40], [1, 1, 2]);
logger.debug('Start position: [40, 40]');
settings.targetPosition = reshape([210; 210], [1, 1, 2]);
logger.debug('End position: [210, 210]');
settings.radius = 10;
logger.debug(sprintf('Radius: %d', settings.radius));
settings.sensorAngles = [-60; -40; -20; 0; 20; 40; 60];
logger.debug('Sensor angles: [-61 -40 -20 0 20 40 60]');
settings.sensorLen = 40;
logger.debug(sprintf('Sensor len: %d', settings.sensorLen));
settings.maxSpeed = 10;
logger.debug(sprintf('Max speed: %d', settings.maxSpeed));
settings.initAngle = 0;
logger.debug(sprintf('Init angle: %d', settings.initAngle));
settings.duration = 1;
logger.debug(sprintf('Duration: %d', settings.duration));

settings.step_count = 250;
logger.debug(sprintf('Step count: %d', settings.step_count));
settings.gen_count = 1000;
logger.debug(sprintf('Gen count: %d', settings.gen_count));
settings.pop_count = 150;
logger.debug(sprintf('Pop size: %d', settings.pop_count));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map Settings
settings.cmap = create_cmap(settings.pop_count);
%logger.debug('Map: Simple map');
%settings.map = MapFactory.basic_map(250, 250, 20, 50, 3);
logger.debug('Map: map_4_path_2.png');
settings.map = MapFactory.from_img('../maps/map_4_path_2.png');
max_distance = sqrt(size(settings.map, 1)^2 + size(settings.map, 2)^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


settings.net = initNet(settings.netLayout);
settings.robot = Robot(settings.radius, settings.sensorAngles, ...
    settings.sensorLen, settings.maxSpeed, settings.net);
body = get_body(settings.radius)';
settings.body = reshape(body, [length(body), 1, 2]);
save(sprintf('logs/%s/settings', experiment), 'settings')

% start with new (random init)
%Pop = generateWBs(settings.netLayout, settings.pop_count)';
% or zeros
logger.debug('Population initialized as zeros');
Pop = zeros(settings.pop_count, calculateWBCount(settings.netLayout));
% or load existing
%old_exp_id = '737176832';
%old_gen_id = 223;
%old_pop_path = sprintf('logs/%s/pop-gen-%d.mat', old_exp_id, old_gen_id);
%logger.debug(sprintf('Initializing with : "%s"', old_pop_path));
%Pop = load(old_pop_path);
%Pop = Pop.Pop;

M=2;
lstring=size(Pop, 2);
Space=[-M*ones(1,lstring); M*ones(1,lstring)];  %pracovny priestor
Sigma=Space(2,:)/50;%prac ovny priestor mutacie

for gen = 1:settings.gen_count
    logger.debug(sprintf('Gen: %d: ',gen));
    [Fit, dists, collis, path_lens] = fitness_vec_path(Pop, settings.map, settings.net, ...
        settings.robot, settings.body, settings.initPosition, ...
        settings.targetPosition, settings.initAngle, settings.step_count, ...
        settings.cmap, max_distance);
    data = {};
    data.Pop = Pop;
    data.Fit = Fit;
    data.dists = dists;
    data.collis = collis;
    data.path_lens = path_lens;
    save(sprintf('logs/%s/out-data-gen-%d', experiment, gen), 'data');
    [BestGenome, BestFit]=selbest(Pop,Fit',[1,1,1,1,1]);
    logger.debug(sprintf('Best fits: [%f %f %f %f %f]', BestFit));
    Old=seltourn(Pop,Fit',15);
    Work1=selsus(Pop,Fit',30);
    Work2=seltourn(Pop,Fit',50);
    Work1=crossov(Work1,1,0);
    Work2=muta(Work2,0.1,Sigma,Space);
    Work2=mutx(Work2,0.1,Space);
    Pop=[BestGenome;Old;Work1;Work2];
end
logger.debug(sprintf('End of simulation: %s', experiment));

