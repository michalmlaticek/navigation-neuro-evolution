function draw_map(map, cmap, bodies, sensor_lines, start, target, ...
    collis_idx)
    map2draw = map;
    for r = 1:size(bodies, 2) % for each robot
        if exist('collis_idx', 'var') && collis_idx(r) > 0
            map2draw = draw_body(map2draw, bodies(:, r, :), 4);
        else
            map2draw = draw_body(map2draw, bodies(:, r, :), r + 4);
        end
        map2draw = draw_sensors(map2draw, sensor_lines{r}, r + 4);
    end
    
    map2draw(start(1), start(2)) = 2;
    map2draw(target(1), target(2)) = 3;
    image(map2draw, 'CDataMapping', 'direct');
    colormap(cmap);
    axis image
end

function map = draw_body(map, body, c_idx)
    for i = 1:size(body, 1)
        if body(i, 1, 1) > 0 && ...
                body(i, 1, 2) > 0 && ...
                body(i, 1, 1) <= size(map, 1) && ...
                body(i, 1, 2) <= size(map, 2)
            map(body(i, 1, 1), body(i, 1, 2)) = c_idx;            
        end            
    end
end

function map = draw_sensors(map, robot_sensors, c_idx)
    for i = 1:length(robot_sensors)
       map = draw_sensor(map, robot_sensors{i}, c_idx);
    end
end

function map = draw_sensor(map, sensor, c_idx)
   for i = 1:length(sensor)
       if sensor(1, i) > 0 && ...
               sensor(2, i) > 0 && ...
               sensor(1, i) <= size(map, 1) && ...
               sensor(2, i) <= size(map, 2)
            map(sensor(1, i), sensor(2, i)) = c_idx;
       end
   end
end