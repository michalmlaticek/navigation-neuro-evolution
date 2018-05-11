function a_metric(start_gen, end_gen, to_csv)
    cd_here();
    gen_count = end_gen - start_gen + 1;

    fits = [];
    metric_labels = [];
    metric_data = [];
    pop_diversity = [];


    % load data
    for i = start_gen:end_gen
        %collisions
        data = load(sprintf('out-data-gen-%d.mat', i));
        data = data.data;    
        metric_labels = fieldnames(data);
        metric_labels(find(strcmpi(metric_labels, 'POP')), :) = []; % del 'Pop' label
        
        pop_diversity(i-start_gen+1, :) = size(unique(data.Pop, 'rows'), 1);
        
        fit_label_idx = find(strcmpi(metric_labels, 'FIT'));
        if isempty(fit_label_idx)
            fit_label_idx = find(strcmpi(metric_labels, 'FITS'));
        end        
        fits(i-start_gen+1, :) = data.(metric_labels{fit_label_idx});
        metric_labels(fit_label_idx, :) = [];

        for ml = 1:length(metric_labels)
            metric_data(i-start_gen+1, :, ml) = data.(metric_labels{ml});
        end
    end
    
    if exist('to_csv', 'var') && to_csv
        writetable(array2table(fits), 'fits.csv');
        for label = 1:length(metric_labels)
           writetable(array2table(metric_data(:, :, label)), sprintf('%s.csv', metric_labels{label})); 
        end   
    end

    [best_fit, best_fit_idx] = min(fits, [], 2);

    % prepare interesting values
    metric_count = length(metric_labels);
    best_fit_metric = zeros(gen_count, metric_count);
    for i = 1:gen_count
        best_fit_metric(i, :) = metric_data(i, best_fit_idx(i), :);
    end

    f1 = figure('Name', sprintf('%s - Best fitness', extract_fit_title()), 'NumberTitle', 'off');
    subplot(metric_count+1, 1, 1);
    hold on;
    lines = plot(best_fit, 'o', 'MarkerSize',2); labels = "Fitness";
    xlim([0 inf]);
    ylim([0 inf]);
    title("Best fitness");
    xlabel("Generation");
    legend(lines, labels);
    hold off
    
    for i = 1:metric_count
        subplot(metric_count + 1, 1, i + 1);
        hold on;
        lines = plot(best_fit_metric(:,i), 'o', 'MarkerSize',2); labels = metric_labels{i};
        xlim([0 inf]);
        ylim([0 inf]);
        title(sprintf("Best %s", labels));
        xlabel("Generation");
        legend(lines, labels);
        hold off
    end
    
    f2 = figure('Name', sprintf('%s - metric values (min, max, mean)', extract_fit_title()), 'NumberTitle', 'off');
    for mc = 1:metric_count
        subplot(metric_count, 1, mc);
        hold on;
        line1 = plot(mean(metric_data(:,:,mc), 2), 'og', 'MarkerSize',2); label1 = "mean";
        line2 = plot(max(metric_data(:,:,mc), [], 2), 'ob', 'MarkerSize', 2); label2 = "max";
        line3 = plot(min(metric_data(:,:,mc) , [], 2), 'or', 'MarkerSize',2); label3 = "min";
        xlim([0 inf]);
        ylim([0 inf]);
        title(metric_labels{mc});
        xlabel("Generation");
        legend([line1 line2 line3], [label1 label2 label3]);
        hold off
    end
    
    
    % plot population diversity in each generation
    f3 = figure('Name', sprintf('%s - Population diversity', extract_fit_title()), 'NumberTitle', 'off');
    hold on
    line = plot(pop_diversity, 'o', 'MarkerSize', 2); label = "Unique Genom Count";
    xlim([0 inf]);
    ylim([0 inf]);
    legend(line, label);
    hold off
    
end

function cd_here()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
    cd(folder_path);
end

function title = extract_fit_title()
    str = pwd;
    idx = strfind(str,'\');
    title = str(idx(end-1)+1:end);
end
