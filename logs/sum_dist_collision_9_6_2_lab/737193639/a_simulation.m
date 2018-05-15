function a_simulation(gen_id, relative_fits, init_position, target_position, ...
    step_count, custom_gif_name)
    cd_here();
    add_paths();

    settings = load('settings');

    %settings.step_count = 600;

    global logger; logger = Logger('', 'simulation-run.log');
    global draw; draw = true;
    global save_gif; save_gif = true;
    global gif_name; gif_name = sprintf('simulation_gen_%d', gen_id);
    global draw_refresh_rate; draw_refresh_rate = 0.1;


    %load population
    data = load(sprintf('out-data-gen-%d.mat', gen_id));
    Pop = data.data.Pop;
    Fit = data.data.fits;
    
    % create a unique population
    Pop = [Fit' Pop];
    Pop = unique(Pop, 'rows');
    Pop = Pop(:, 2:end);
    
    if exist('relative_fits', 'var') && ~isempty(relative_fits)
        rel_fits_valid_idx = relative_fits <= size(Pop, 1);
        Pop = Pop(relative_fits(rel_fits_valid_idx), :);
    end
    
    if exist('init_position', 'var') && ~isempty(init_position)
       settings.initPosition = reshape(init_position, [1, 1, 2]); 
    end
    
    if exist('target_position', 'var') && ~isempty(target_position)
        settings.targetPosition = reshape(target_position, [1, 1, 2]); 
    end
    
    if exist('step_count', 'var') && ~isempty(step_count)
       settings.step_count = step_count;
    end
    
    if exist('custom_gif_name', 'var') && ~isempty(custom_gif_name)
        gif_name = custom_gif_name;
    end
    
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