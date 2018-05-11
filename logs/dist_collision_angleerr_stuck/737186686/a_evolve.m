function a_evolve(Pop, settings, log_folder, start_gen, end_gen)
    global logger;

    for gen = start_gen:end_gen
        logger.debug(sprintf('Gen: %d: ',gen));

        data = a_fitness(Pop, settings.map, settings.netLayout, ...
            settings.robot, settings.body, settings.initPosition, settings.targetPosition, ...
            settings.initAngle, settings.step_count, settings.cmap, settings.max_distance, ...
            settings);

        data.Pop = Pop;
        save(sprintf('%s/out-data-gen-%d', log_folder, gen), 'data');
        
        [best_fit, best_fit_idx] = min(data.fits, [], 2);
        logger.debug(sprintf('Best Fit: %f    Distance: %f    Collision: %d    Path len: %f    Rotation: %d', ...
            best_fit, data.distances(best_fit_idx), data.collisions(best_fit_idx), ...
            data.path_lens(best_fit_idx), data.rotations(best_fit_idx)));
        
        Pop=a_gen_pop(data, settings);
    end    
end

