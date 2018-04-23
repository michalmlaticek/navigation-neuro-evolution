%addpath('..','../../maps','../classes','../utils');
addpath('../maps','classes','utils', '../logs');
%load('../../maps/map2');

global experiment
experiment = 'AxBx_aEplusdE_';

%load('../maps/map2');
%map = map2;

load('logs/state_42');


map = uint8(ones(250, 250));
map(100:150, 100:150) = 0;

map(:, 46) = 0; map(46,:) = 0; map(:, length(map)-46) = 0; map(length(map)-46, :) = 0;
netLayout = [7 9 7 2];
% netLayout = [7 9 7 1];
net = initNet(netLayout);

initPosition = [65;65];
targetPosition = [175; 175]; % 190, 190
radius = 15;
sensorAngles = [-60; -30; 0; 30; 60];
sensorLen = 30;
maxSpeed = 10;

duration = 1;
stepCount = 5000;

robot = MapRobot(1, 0, initPosition, radius, sensorAngles, sensorLen, maxSpeed, net, targetPosition);
% wbs = generateWBs(netLayout);
wbs = state.Population(1, :);
fitness(wbs, map, robot, targetPosition, duration, stepCount, true)

% f = @(weights) fitness(weights, map, robot, targetPosition, duration,...
%     stepCount, false);
% wbCount = calculateWBCount(netLayout);
% topRange = ones(1, wbCount);
% bottomRange = zeros(1, wbCount);
% popRange = [bottomRange; topRange];
% 
% %'PlotFcn', @gaplotbestf, ...    
% gaopts = optimoptions('ga', ...
%     'CreationFcn', @gacreationuniform, ...
%     'PopInitRange', popRange, ...
%     'display', 'iter', ...
%     'OutputFcns', @mygaoutputfcn ...
% );
% [w, fval, exitflag, output, population, score] = ga(f, wbCount, [], [], [], [], 0, 1, [], gaopts);
% save('logs/w', 'w');
% save('logs/fval', 'fval');
