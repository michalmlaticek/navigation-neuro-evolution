classdef Logger
    %LOGGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fid
    end
    
    methods
        function log = Logger(folderPath, logName)
            mkdir(folderPath)
            log.fid = fopen(fullfile(folderPath, logName), 'a');
            if log.fid == -1
                error('Cannot open log file.');
            end
        end
        
        function log = debug(log, msg)
            fprintf(log.fid, '%s: %s\n', datestr(now, 0), msg);
            disp(msg);
        end
        
        function log = close(log)
            fclose(log.fid);
        end
    end
end

