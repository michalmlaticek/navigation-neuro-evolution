function [im, map2draw] = draw_map(map, cmap, bodies, sensor_lines, start, target, ...
    collis_idx, gif, gif_name)
    map2draw = map;
    for r = 1:size(bodies, 2) % for each robot
        if exist('collis_idx', 'var') && ~isempty(collis_idx) && collis_idx(r) > 0
            map2draw = draw_body(map2draw, bodies(:, r, :), 4);
        else
            map2draw = draw_body(map2draw, bodies(:, r, :), r + 4);
        end
        map2draw = draw_sensors(map2draw, sensor_lines{r}, r + 4);
    end
    
    map2draw(start(1), start(2)) = 2;
    map2draw(target(1), target(2)) = 3;
    im = image(map2draw, 'CDataMapping', 'direct');
    colormap(cmap);
    axis image
    
    if exist('gif','var') && ~isempty(gif)
       if exist('gif_name', 'var') && ~isempty(gif_name)
           if exist(gif_name, 'file') == 2
               imwrite(map2draw,cmap,sprintf('%s.gif', gif_name),'gif','DelayTime',0.1, 'WriteMode','append'); 
           else
               imwrite(map2draw,cmap,sprintf('%s.gif', gif_name),'gif', 'DelayTime',0.1,  'Loopcount',inf);
           end
       else
           if exist('simulation.gif', 'file') == 2
               imwrite(map2draw,cmap,'simulation.gif','gif','DelayTime',0.1, 'WriteMode','append'); 
           else
               imwrite(map2draw,cmap,'simulation.gif','gif', 'DelayTime',0.1,  'Loopcount',inf);
           end
       end
    end
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