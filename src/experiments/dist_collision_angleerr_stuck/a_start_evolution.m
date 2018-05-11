function a_start_evolution()
    cd_here();    
    add_paths();

    rng_id = round(now*1000);
    run_id = sprintf('%9.0f', rng_id);
    rng(rng_id)
    
    % Extract folder name, that serves as experiment root id
    experiment_root = extract_experiment_name();
    
    experiment = sprintf('%s/%s', experiment_root, run_id);
    log_folder = sprintf('../../../logs/%s', experiment);
    
    global draw; draw = true;
    global draw_refresh_rate; draw_refresh_rate = 0.001;
    global logger; logger = Logger(log_folder, 'experiment.log');    
    
    logger.debug('Coppining src files to log folder');
    copy_src([{'a_start_evolution.m'}, {'a_continue_evolution.m'}, {'a_fitness.m'}, {'a_settings.m'}, ...
        {'a_metric.m'}, {'a_simulation.m'}, {'add_paths.m'}, {'a_evolve.m'}, {'a_fitness_path.m'}], ...
        log_folder);

    logger.debug('Loading settings');
    settings = a_settings();
    save(sprintf('%s/settings', log_folder), '-struct', 'settings')

    % start with new (random init)
    %Pop = generateWBs(settings.netLayout, settings.pop_count)';
    % or zeros
    Pop = zeros(settings.pop_count, settings.genom_len);

    a_evolve(Pop, settings, log_folder, 1, settings.gen_count)
    logger.debug(sprintf('End of simulation: %s', experiment));
end

function cd_here()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
    cd(folder_path);
end

function name = extract_experiment_name()
    str = pwd;
    idx = strfind(str,'\');
    name = str(idx(end)+1:end);
end

function copy_src(to_copy, log_folder)
    for i = 1:length(to_copy)
        copyfile(to_copy{i}, log_folder);
    end
end

