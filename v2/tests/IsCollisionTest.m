classdef IsCollisionTest < matlab.unittest.TestCase
    %ISCOLLISIONTEST Summary of this class goes here
    %   Detailed explanation goes here
    
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
        function obj = IsCollisionTest_true(test)
            map = ones(100, 100);
            map(55, 50) = 0;
            robot = MapRobot(1, 0, [50;50], 15, [-60 -30 0 30 60], 30, network());
            
            actual = isCollision(robot, map);
            
            test.assertTrue(actual)
        end
        
        function obj = IsCollisionTest_false(test)
            map = ones(100, 100);
            map(66, 50) = 0;
            robot = MapRobot(1, 0, [50;50], 15, [-60 -30 0 30 60], 30, network());
            
            actual = isCollision(robot, map);
            
            test.assertFalse(actual)
        end
    end
end

