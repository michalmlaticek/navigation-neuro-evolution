function cmap = create_cmap(robot_count)
    cmap = [0 0 0; ... % obstacle color
            1 1 1; ... % free color
            0 0 1; ... % start color
            0 1 0; ... % target
            1 0 0  ... % collision
           ];
       
     for i = 1: robot_count
        r_color = [i i i] / 255;
        %s_color = [i i i] * 2 / 255;
        cmap = [cmap; r_color];
     end
end

