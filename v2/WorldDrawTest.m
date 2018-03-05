load '../maps/map2';
map2 = map2 - 1;
net = initNet([7 15 10 2]);
robot = MapRobot(1, 30, [50;50], 15, [-60 -30 0 30 60], 30, net);
world = World(map2, robot);
world.draw();
pause(1);

% test movement
steps = {};

steps{end+1} = world.moveRobotTest(1, [100;100], 1, 15, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, 15, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, -5, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, -10, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, 0, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, 15, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, 15, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, -5, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, -10, 10);
world.draw();
pause(1);
steps{end+1} = world.moveRobotTest(1, [100;100], 1, 0, 10);
world.draw();

for i = 1:length(steps) 
    steps{i}
end

% test colision
