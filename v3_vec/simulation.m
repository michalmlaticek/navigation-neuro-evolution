rng(2)

global experiment
global global_state
global draw
global draw_refresh_rate
global logger

experiment = '22_04_2018';
global_state = {};
draw = false;
draw_refresh_rate = 0.01;

log_folder = sprintf('logs/%s', experiment);

addpath('../maps', 'classes', 'utils', log_folder);

logger = Logger(log_folder, 'simulation.log');

map = MapFactory.basic_map(250, 250, 20, 50, 3);

netLayout = [9 3 3 3 2];
% netLayout = [7 9 7 1];
net = initNet(netLayout);

initPosition = reshape([65;65], [1, 1, 2]);
targetPosition = reshape([175; 175], [1, 1, 2]); % 190, 190
radius = 15;
sensorAngles = [-60; -40; -20; 0; 20; 40; 60];
sensorLen = 40;
maxSpeed = 15;
initAngle = 0;
duration = 1;
stepCount = 300;

robot = Robot(radius, sensorAngles, sensorLen, maxSpeed, net);
body = get_body(radius)';
body = reshape(body, [length(body), 1, 2]);

% wbs = generateWBs(netLayout);
% wbs = state.Population(1, :);
%fitness(wbs, map, robot, targetPosition, duration, stepCount)

cmap = create_cmap(200);

f = @(weights) fitness_vec(weights, ...
    map, ...
    net, ...
    robot, ...
    body, ...
    initPosition, ...
    targetPosition, ...
    initAngle,...
    stepCount,...
    cmap);
wbCount = calculateWBCount(netLayout);
topRange = ones(1, wbCount);
bottomRange = zeros(1, wbCount);
popRange = [bottomRange; topRange];

%'PlotFcn', @gaplotbestf, ...    
gaopts = optimoptions('ga', ...
    'CreationFcn', @gacreationuniform, ...
    'PopInitRange', popRange, ...
    'display', 'iter', ...
    'OutputFcns', @mygaoutputfcn, ...
    'UseVectorized', true, ...
    'PopulationSize', 50 ...
);
[w, fval, exitflag, output, population, score] = ga(f, wbCount, [], [], [], [], 0, 1, [], gaopts);
save(sprintf('logs/w_%s', experiment), 'w');
save(sprintf('logs/fval_%s', experiment), 'fval');
