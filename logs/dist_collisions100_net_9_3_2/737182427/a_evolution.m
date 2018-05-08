function a_evolution()
clc
clear

rng_id = round(now*1000);
run_id = sprintf('%9.0f', rng_id);

rng(rng_id)

global draw
global draw_refresh_rate
global logger

draw = false;
draw_refresh_rate = 0.001;

% Extract folder name, that serves as experiment root id
experiment_root = extract_experiment_name();

experiment = sprintf('%s/%s', experiment_root, run_id);
log_folder = sprintf('logs/%s', experiment);
add_paths(log_folder);

logger = Logger(log_folder, 'simulation.log');
logger.debug(sprintf('Start of experiment: %s', experiment));

logger.debug('Coppining src files to log folder')
copy_src(['a_evolution.m', 'a_fitness.m', 'a_settings.m', 'a_metric.m', 'a_simulation.m'], ...
    log_folder);


logger.debug('Loading settings');
settings = a_settings();


% start with new (random init)
%Pop = generateWBs(settings.netLayout, settings.pop_count)';
% or zeros
Pop = zeros(settings.pop_count, calculateWBCount(settings.netLayout));

% or load existing
%old_exp_id = '737176832';
%old_gen_id = 223;
%old_pop_path = sprintf('logs/%s/pop-gen-%d.mat', old_exp_id, old_gen_id);
%logger.debug(sprintf('Initializing with : "%s"', old_pop_path));
%Pop = load(old_pop_path);
%Pop = Pop.Pop;

lstring=size(Pop, 2);
Space=[-settings.M*ones(1,lstring); settings.M*ones(1,lstring)];  % working space
Sigma=Space(2,:)/50; %mutation working space

for gen = 1:settings.gen_count
    logger.debug(sprintf('Gen: %d: ',gen));
    data = fitness(Pop, settings.map, settings.netLayout, ...
        robot, body, settings.initPosition, settings.targetPosition, ...
        settings.initAngle, settings.step_count, settings.cmap, max_distance)
    save(sprintf('logs/%s/out-data-gen-%d', experiment, gen), 'data');
    
    Fit = data.fits;
    BestGenome=selbest(Pop,Fit',[1,1,1,1,1]);
    Old=seltourn(Pop,Fit',15);
    Work1=selsus(Pop,Fit',30);
    Work2=seltourn(Pop,Fit',50);
    Work1=crossov(Work1,1,0);
    Work2=muta(Work2,0.1,Sigma,Space);
    Work2=mutx(Work2,0.1,Space);
    Pop=[BestGenome;Old;Work1;Work2];
end
logger.debug(sprintf('End of simulation: %s', experiment));
end

function name = extract_experiment_name()
    str = pwd;
    idx = strfind(str,'\');
    name = str(idx(end)+1:end);
end

function copy_src(to_copy, log_folder)
    for i = 1:lenght(to_copy)
        copyfile(to_copy(i), log_folder);
    end
end

