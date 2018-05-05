function a_continue_evolution(gen_id)
    %rng_id = round(now*1000);
    %run_id = sprintf('%9.0f', rng_id);
    %rng(rng_id)

    global draw
    global draw_refresh_rate
    global logger

    draw = false;
    draw_refresh_rate = 0.001;

    % Extract folder name, that serves as experiment root id
    log_folder = pwd;
    
    add_paths();

    logger = Logger(log_folder, 'simulation.log');
    logger.debug('***************************************************');
    logger.debug(sprintf('Continue experiment: %s', experiment));

    logger.debug('Loading settings');
    settings = load('settings');
    logger.debug(sprintf('Loading generation: %d', gen_id));
    data = load(old_pop_path);
    Pop = data.data.pop;
    
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
        data = fitness(Pop, settings.map, settings.netLayout, ...
            robot, body, settings.initPosition, settings.targetPosition, ...
            settings.initAngle, settings.step_count, settings.cmap, max_distance);
        
        data.pop = Pop; % add population
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

