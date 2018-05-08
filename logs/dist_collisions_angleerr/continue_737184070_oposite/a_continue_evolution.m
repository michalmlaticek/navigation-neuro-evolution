function a_continue_evolution(gen_id)
    cd_here();
    rng_id = round(now*1000);
    run_id = sprintf('%9.0f', rng_id);
    rng(rng_id)

    global draw
    global draw_refresh_rate
    global logger

    draw = false;
    draw_refresh_rate = 0.001;

    % Extract folder name, that serves as experiment root id
    log_folder = pwd;
    
    add_paths();

    logger = Logger(log_folder, 'experiment.log');
    logger.debug('***************************************************');
    logger.debug(sprintf('Continue experiment: %s', extract_experiment_name()));

    logger.debug('Loading settings');
    settings = load('settings');
    
    % switch start / end point
    tmp = settings.targetPosition;
    settings.targetPosition = settings.initPosition;
    settings.initPosition = tmp;
    
    logger.debug(sprintf('Loading generation: %d', gen_id));
    data = load(sprintf('out-data-gen-%d', gen_id));
    Pop = data.data.Pop;
    
    lstring=size(Pop, 2);
    Space=[-settings.M*ones(1,lstring); settings.M*ones(1,lstring)];  % working space
    Sigma=Space(2,:)/50; %mutation working space
    
    Fit = data.data.fits;
    BestGenome=selbest(Pop,Fit',[1,1,1,1,1]);
    Old=seltourn(Pop,Fit',15);
    Work1=selsus(Pop,Fit',30);
    Work2=seltourn(Pop,Fit',50);
    Work1=crossov(Work1,1,0);
    Work2=muta(Work2,0.1,Sigma,Space);
    Work2=mutx(Work2,0.1,Space);
    Pop=[BestGenome;Old;Work1;Work2];
    
    gen_id = gen_id + 1;

    for gen = gen_id:settings.gen_count + gen_id
        logger.debug(sprintf('Gen: %d: ',gen));
        data = a_fitness(Pop, settings.map, settings.netLayout, ...
            settings.robot, settings.body, settings.initPosition, settings.targetPosition, ...
            settings.initAngle, settings.step_count, settings.cmap, settings.max_distance);
        
        data.Pop = Pop; % add population
        save(sprintf('out-data-gen-%d', gen), 'data');
        
        [best_fit, best_fit_idx] = min(data.fits, [], 2);
        logger.debug(sprintf('Best Fit: %f    Distance: %f    Collision: %d', ...
            best_fit, data.distances(best_fit_idx), data.collisions(best_fit_idx)));
        if data.distances(best_fit_idx) == 0.0 && data.collisions(best_fit_idx) == 0
           break; 
        end

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
    logger.debug(sprintf('End of simulation: %s', extract_experiment_name()));
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
    name = str(idx(end-1)+1:end);
end