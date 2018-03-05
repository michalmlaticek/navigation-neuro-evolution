% init input Count


% init net
nn = initNet(238, [25 15 1]);

% init world
load 'maps/map2';
world = World(map2);

%init robot
robot = Robot(5, 10, 0);

%init start position
start = [50;50];
% init target position
target = [450; 450];

% init step size
stepSize = 5;

% init step count
stepCount = 100;

% init fitenss
%f = @(weights) fitness(weights, nn, robot, world, start, target, stepSize, stepCount);

% init number of Weights + biases
wbCount = (238+1)*25 + (25+1)*15 + (15+1)*1;

% test fitness
wbs = rand(wbCount, 1);
fitness(wbs, nn, robot, world, start, target, stepSize, stepCount);

% run GA
%[w, fval] = ga(f, wbCount)




