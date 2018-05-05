function a_simulation(gen_id)
    cd_here();
    add_paths();

    settings = load('settings');

    %settings.step_count = 600;

    global logger;
    logger = Logger('', 'simulation-run.log');
    global draw;
    draw = true;
    global draw_refresh_rate;
    draw_refresh_rate = 0.1;


    %load population
    data = load(sprintf('out-data-gen-%d.mat', gen_id));
    Pop = data.data.Pop;

    figure;

    a_fitness(Pop, settings.map, settings.netLayout, ...
            settings.robot, settings.body, settings.initPosition, ...
            settings.targetPosition, settings.initAngle, settings.step_count, ...
            settings.cmap, settings.max_distance);
    
end

function cd_here()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
    cd(folder_path);
end