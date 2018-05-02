function [fits, target_distances, collisions, combined_angle_errs] = fitness_dist_collisions100(weights, ...
    map, ...
    net_layout, ...
    robot, ...
    body, ...
    start_positions, ...
    target_positions, ...
    init_angles, ...
    step_count, ...
    cmap, ...
    max_distance)

global draw
global draw_refresh_rate
global logger

weights = weights';
pop_size = size(weights, 2);

logger.debug('Initializing networks');
nets = init_nets(net_layout, weights);
logger.debug('Initializing remaining params');
robot_angles = zeros(1, pop_size) + init_angles;
sensor_angles = zeros(length(robot.sensorAngles), pop_size) ...
    + to_minus_pi_pi(robot.sensorAngles);

robot_positions = zeros(1, pop_size, 2) + start_positions;
robot_bodies = round(robot_positions + body);
sensor_lines = get_sensor_lines(sensor_angles, robot_positions, robot);

angle_errors = get_angle_errors(robot_positions, robot_angles, target_positions);
norm_angle_errors = normalize_angles(angle_errors);
target_distances = euc_dist_3d(robot_positions, target_positions);
norm_target_distances = normalize_distance(target_distances, max_distance);
collisions = zeros(1, pop_size);
combined_angle_errs = zeros(1, pop_size);

if draw
   draw_map(map, cmap, robot_bodies, sensor_lines, start_positions, target_positions)
   pause(draw_refresh_rate);
end

logger.debug('Starting steps');
for step = 1:step_count
    %logger.debug('Preparing inputs')
   net_inputs = create_inputs(sensor_lines, robot.sensorLen, ...
       norm_angle_errors, norm_target_distances, map);
   %logger.debug('Calculating outputs (running networks)')
   net_outputs = eval_nets(nets, net_inputs);
   
   %logger.debug('Updating inner params')
   [d_angles, d_speeds] = extract_outputs(net_outputs, robot.maxSpeed);
   
   [robot_angles, sensor_angles] = rotate(robot_angles, sensor_angles, d_angles);
   [robot_positions, robot_bodies] = translate(robot_positions, body, robot_angles, d_speeds);
   sensor_lines = get_sensor_lines(sensor_angles, robot_positions, robot);
   
   if draw
        draw_map(map, cmap, robot_bodies, sensor_lines, start_positions, target_positions)
        pause(draw_refresh_rate);
   end
   
   angle_errors = get_angle_errors(robot_positions, robot_angles, target_positions);
   norm_angle_errors = normalize_angles(angle_errors);
   target_distances = euc_dist_3d(robot_positions, target_positions);
   norm_target_distances = normalize_distance(target_distances, max_distance);
   
   [collis, targets] = get_collisions_and_targets(map, robot_bodies, robot_positions, target_positions);
   
   % tracking for fitness
   collisions = collisions + collis;
   combined_angle_errs = combined_angle_errs + angle_errors.^2;
end % for step

fits = calc_fitnesses(target_distances, collisions, combined_angle_errs);
end

function [colision_indicators, target_indicators] = get_collisions_and_targets(map, bodies, positions, target)
    colision_indicators = zeros(1, size(positions, 2));
    target_indicators = zeros(1, size(positions, 2));
    for i = 1:size(positions, 2)
        if is_collision(bodies(:, i, :), map)
            colision_indicators(1, i) = 1;
        elseif is_target(round(positions(:, i)), target)
            target_indicators(1, i) = 1;
        end
    end
end

function ins = create_inputs(sensor_lines, sensor_len, angle_errors, target_distances, map)
    readings = read_sensors(sensor_lines, sensor_len, map);
    normalized_readings = normalize_sensor_readings(readings, sensor_len);
    
    ins = [normalized_readings; angle_errors; target_distances];
end

function [d_angles, d_speeds] = extract_outputs(outs, max_speed)
    %d_angles = (outs(1, :) * 2 * pi) - pi;
    %d_speeds = outs(2, :) * max_speed;
    d_angles = outs(1, :) * pi;
    d_speeds = (outs(2, :) + 1) * (max_speed/2);
end

function [robot_angles, sensor_angles] = rotate(robot_angles, sensor_angles, rotation_angles)
    robot_angles = to_minus_pi_pi(robot_angles + rotation_angles);
    sensor_angles = to_minus_pi_pi(sensor_angles + rotation_angles);
end

function [new_positions, new_bodies] = translate(robot_positions, robot_body, robot_angles, speeds)
    new_positions = get_coordinates(robot_positions, robot_angles, speeds);
    new_bodies = round(robot_body + new_positions);
end

function angles = to_minus_pi_pi(angles)
    angles = mod((angles + pi), (2 * pi)) - pi; 
end

function xys = get_coordinates(start_xys, angles, hypotenuses)
    sin_mat = sin(angles);
    cos_mat = cos(angles);
    dxy = cat(3, cos_mat, sin_mat) .* hypotenuses;
    xys = dxy + start_xys;
end

function lines_lists = calc_line_coordinates(start_xys, end_xys)
    start_xys = round(start_xys);
    end_xys = round(end_xys);
    lines_lists = cell(1, size(start_xys, 2));
    for col = 1:size(start_xys, 2)
        lines = cell(1, size(start_xys, 1));
        for row = 1:size(start_xys, 1)
            lines{row} = bresenham(start_xys(row, col, :), end_xys(row, col, :));
        end % for row
        lines_lists{col} = lines;
    end % for col
end

function sensor_lines = get_sensor_lines(sensor_angles, robot_positions, robot)
    % sensor_start_points
    sensor_start_xys = get_coordinates(robot_positions,  ...
                                       sensor_angles, robot.radius);
    
    % sensor_end_points
    sensor_end_xys = get_coordinates(robot_positions, ...
                                    sensor_angles, ...
                                    (robot.radius + robot.sensorLen));
    
    % sensor_line_coordinates
    sensor_lines = calc_line_coordinates(sensor_start_xys, sensor_end_xys);
end

function angle_errors = get_angle_errors(robot_positions, robot_angles, targets)
    rebased_targets = targets - robot_positions;
    target_angles = atan2(rebased_targets(1, :, 2), rebased_targets(1, :, 1));
    angle_errors = to_minus_pi_pi(target_angles - robot_angles);
end

function normalized_angles = normalize_angles(angles)
    normalized_angles = (angles + pi) / (2*pi);
end

function target_distances = euc_dist_3d(robot_positions, targets)
    st_dxy = targets - robot_positions;
    st_dxy_power2 = st_dxy.^2;
    sum_power = sum(st_dxy_power2, 3);
    target_distances = sqrt(sum_power);
end

function target_distances = euc_dist_2d(robot_positions, targets)
    st_dxy = targets - robot_positions;
    st_dxy_power2 = st_dxy.^2;
    sum_power = sum(st_dxy_power2, 1);
    target_distances = sqrt(sum_power);
end

function normalized_distances = normalize_distance(distances, max_distance)
    normalized_distances = distances ./ max_distance;
end

function readings = read_sensors(sensor_lines, sensor_len, map)
    robot_count = length(sensor_lines);
    sensor_count = length(sensor_lines{1});
    
    readings = zeros(sensor_count, robot_count) + sensor_len;
    for robot = 1:robot_count
        for sensor = 1:sensor_count
            xy = sensor_lines{robot}{sensor};
            for line_point = 1:size(xy, 2)
                if xy(1, line_point) < 1 || ...
                        xy(2, line_point) < 1 || ...
                        xy(1, line_point) > size(map, 1) || ...
                        xy(2, line_point) > size(map, 2) || ...
                        map(xy(1, line_point), xy(2, line_point)) ~= 1 % 1 means free
                    readings(sensor, robot) = euc_dist_2d(xy(:, 1), xy(:,line_point));
                    continue;
                end
            end % for line_point
        end % for sensor
    end % for robots
end

function normalized_readings = normalize_sensor_readings(readings, sensor_len)
    normalized_readings = 1 - readings/sensor_len;
end

function bool_result = is_collision(body, map)
    bool_result = false;
    for i = 1:size(body, 1)
       if body(i, 1, 1) > size(map, 1) || ...
           body(i, 1, 2) > size(map, 2) || ...
           body(i, 1, 1) < 1 || ...
           body(i, 1, 2) < 1 || ...
           map(body(i, 1, 1), body(i, 1, 2)) == 0
            bool_result = true;
            break;
       end
    end
end

function bool_result = is_target(robot_position, target)
    bool_result = isequal(round(robot_position), target);
end

%function fitnesses = handle_remaining(net_ids, norm_distance, norm_angle_errs, fitnesses)
%    for i = 1:length(net_ids)
%       fitnesses(net_ids(i)) = cacl_fitness(norm_distance, ...
%           norm_angle_errs, ...
%           1, ...
%            1)
%    end
%end

%function fit = calc_fitness(norm_distance, norm_angle_err, alfa, beta)
%    angle_error = abs(norm_angle_err - 0.5);
%    fit = alfa * beta * (angle_error + norm_distance*10) * -1;
%end

function fitnesses = calc_fitnesses(distances, collisions, combined_angle_errs)
    fitnesses = distances + collisions*100;
end
