function a_simulation(gen_id)
add_paths();

settings = a_settings();

%settings.step_count = 600;

global logger;
logger = Logger(log_folder, 'simulation-run.log');
global draw;
draw = true;
global draw_refresh_rate;
draw_refresh_rate = 0.1;


%load population
data = load(sprintf('out-data-gen-%d.mat', gen_id));
Pop = data.data.Pop;

max_distance = sqrt(size(settings.map, 1)^2 + size(settings.map, 2)^2);

figure;

fitness(Pop, settings.map, settings.netLayout, ...
        settings.robot, settings.body, settings.initPosition, ...
        settings.targetPosition, settings.initAngle, settings.step_count, ...
        settings.cmap, max_distance);
    
end