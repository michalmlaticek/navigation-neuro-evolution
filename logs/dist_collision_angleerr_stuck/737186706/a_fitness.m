function final_data = a_fitness(...
    weights, ...
    map, ...
    net_layout, ...
    robot, ...
    body, ...
    start_positions, ...
    target_positions, ...
    init_angles, ...
    step_count, ...
    cmap, ...
    max_distance, ...
    settings)


    global logger
    
    pop_size = size(weights, 1);
    final_data = {};
    final_data.fits = zeros(1, pop_size);
    final_data.distances = zeros(1, pop_size);
    final_data.collisions = zeros(1, pop_size);
    final_data.cum_angle_errs = zeros(1, pop_size);
    %final_data.rotations = zeros(1, pop_size);
    
    for path = 1:size(start_positions, 2)
        start = start_positions(1, path, :);
        target = target_positions(1, path, :);
        
        data = a_fitness_path(...
            weights, ...
            map, ...
            net_layout, ...
            robot, ...
            body, ...
            start, ...
            target, ...
            init_angles, ...
            step_count, ...
            cmap, ...
            max_distance, ...
            settings);
        
        logger.debug(sprintf('Path %d:', path));
        [best_fit, best_fit_idx] = min(data.fits, [], 2);
        logger.debug(sprintf('Best Fit: %f    Distance: %f    Collision: %d     Angle Err: %f', ...
            best_fit, data.distances(best_fit_idx), data.collisions(best_fit_idx), ...
            data.cum_angle_errs(best_fit_idx)));
        
        final_data.fits = final_data.fits + data.fits;
        final_data.distances = final_data.distances + data.distances;
        final_data.collisions = final_data.collisions + data.collisions;
        final_data.cum_angle_errs = final_data.cum_angle_errs + data.cum_angle_errs;
        %final_data.rotations = final_data.rotations + data.rotations;
    end
    final_data.fits = final_data.fits / size(start_positions, 2);
    final_data.distances = final_data.distances / size(start_positions, 2);
    final_data.collisions = final_data.collisions / size(start_positions, 2);
    final_data.cum_angle_errs = final_data.cum_angle_errs / size(start_positions, 2);
    %final_data.rotations = final_data.rotations / size(start_positions, 2);
end

