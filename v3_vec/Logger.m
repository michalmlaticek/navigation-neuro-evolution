classdef Logger
    %LOGGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        folder
        name
        full_path
    end
    
    methods
        function log = Logger(log_folder, log_name)
            mkdir(log_folder)
            log.folder = log_folder;
            log.name = log_name;
            log.full_path = fullfile(log_folder, log_name);
        end
        
        function log = debug(log, msg)
            fid = fopen(log.full_path, 'a');
            if fid == -1
                error('Cannot open log file.');
            end
            fprintf(fid, '%s: %s\n', datestr(now, 0), msg);
            fprintf('%s: %s\n', datestr(now, 0), msg);
            fclose(fid);
        end
        
        function log = matrix(log, mat)
           dlmwrite(log.fid,M,'-append');
        end
    end
end

