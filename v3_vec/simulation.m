experiment_id = '737175.6974977894';
gen_id = 286;

log_folder = sprintf('logs/%s', experiment_id);

settings = load(sprintf('%s/settings.mat', log_folder));
settings = settings.settings;


global logger;
logger = Logger(log_folder, 'simulation.log');

global draw;
draw = true;

%load population
Pop = load(sprintf('%s/pop-gen-%d.mat', log_folder, gen_id));
Pop = Pop.Pop;

[Fit, dists, collis] = fitness_vec(Pop, settings.map, settings.net, ...
        settings.robot, settings.body, settings.initPosition, ...
        settings.targetPosition, settings.initAngle, settings.step_count, ...
        settings.cmap);