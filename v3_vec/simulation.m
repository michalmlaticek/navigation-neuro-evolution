experiment_id = 'evolution_dist_collisions100_972/737182511';
gen_id = 1266;


log_folder = sprintf('logs/%s', experiment_id);
add_paths(log_folder);

settings = load(sprintf('%s/settings.mat', log_folder));
settings = settings.settings;

%settings.step_count = 600;
global logger;
logger = Logger(log_folder, 'simulation-run.log');

global draw;
draw = true;

global draw_refresh_rate;
draw_refresh_rate = 0.1;


%load population
data = load(sprintf('%s/out-data-gen-%d.mat', log_folder, gen_id));
Pop = data.data.Pop;

max_distance = sqrt(size(settings.map, 1)^2 + size(settings.map, 2)^2);

figure;

[Fit, dists, collis] = fitness_dist_collisions100(Pop(1, :), settings.map, settings.netLayout, ...
        settings.robot, settings.body, settings.initPosition, ...
        settings.targetPosition, settings.initAngle, settings.step_count, ...
        settings.cmap, max_distance);