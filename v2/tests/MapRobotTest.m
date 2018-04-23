classdef MapRobotTest < matlab.unittest.TestCase
    properties
        OriginalPath
    end
    
    methods (TestMethodSetup)
        function addToPath(test)
           test.OriginalPath = path;
           addpath(fullfile(pwd, '..'));
           addpath(fullfile(pwd, '..\utils'));
        end
    end
    
    methods (TestMethodTeardown)
        function restorePath(test)
            path(test.OriginalPath)            
        end
    end
    
    methods (Test)
        function testStepTest(test)
            map = ones(200, 200); % empty map
            map(60,33) = 0;
            map(76,35) = 0;
            map(60,50) = 0;
            map(74,64) = 0;
            map(64,75) = 0;
            robot = MapRobot(1, 0, [50;50], 15, [-60 -30 0 30 60], 30, network());
            
            actual = robot.stepTest(map, [100;100], 1, 45, 10);
            expected = struct( ...
                'dangle', 45*pi/180, ...
                'dangleDeg', 45, ...
                'speed', 10, ...
                'angle', 45*pi/180, ...
                'angleDeg', 45, ...
                'positionX', 50 + sqrt(50), ...
                'positionY', 50 + sqrt(50), ...
                'discretePositionX', round(50 + sqrt(50)), ...
                'discretePositionY', round(50 + sqrt(50)), ...
                'sensorReadings', [
                    mapdistance([50;50], [60;33]); ...
                    mapdistance([50;50], [76;35]); ...
                    mapdistance([50;50], [60;50]); ...
                    mapdistance([50;50], [74;64]); ...
                    mapdistance([50;50], [64;75]); ...                    
                ], ...
                'angleError', 45*pi/180, ...
                'targetDistance', sqrt(50^2 + 50^2) ...
                );
            test.assertEqual(actual, expected);
        end
    end
end
