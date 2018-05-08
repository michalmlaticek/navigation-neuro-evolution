function a_continue_evolution(gen_id)
    cd_here();
    add_paths();

    %rng_id = round(now*1000);
    %run_id = sprintf('%9.0f', rng_id);
    rng(737186582)

    global draw; draw = true;
    global draw_refresh_rate; draw_refresh_rate = 0.001;
    global logger


    % Extract folder name, that serves as experiment root id
    log_folder = pwd;
    
    logger = Logger(log_folder, 'simulation.log');
    logger.debug('***************************************************');
    logger.debug(sprintf('Continue experiment: %s', log_folder));

    logger.debug('Loading settings');
    settings = load('settings');
    logger.debug(sprintf('Loading generation: %d', gen_id));
    data = load(sprintf('out-data-gen-%d', gen_id'));
    
    Pop = a_gen_pop(data.data, settings);
    
    gen_id = gen_id + 1;

    a_evolve(Pop, settings, log_folder, gen_id, gen_id + settings.gen_count)
    logger.debug(sprintf('End of simulation: %s', experiment));
end

function cd_here()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
    cd(folder_path);
end

