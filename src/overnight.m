function overnight()
    addpath dist_collision10_net_9_7_2_pop_200
    evolution();
    rmpath dist_collision10_net_9_7_2_pop_200
    addpath dist_collision10_angleerr001_net_9_3_2_pop_200
    evolution();
    rmpath dist_collision10_angleerr001_net_9_3_2_pop_200
    %evolution_dist_collisions100_972();
    %evolution_dist_collisions100_angleerr01_932();
    %evolution_dist_collisions100_angleerr01_972();
end

