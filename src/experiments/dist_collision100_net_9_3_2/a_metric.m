function a_metric(start_gen, end_gen)

    gen_count = end_gen - start_gen + 1;

    fits = [];
    metric_labels = [];
    metric_data = [];


    % load data
    for i = start_gen:end_gen
        %collisions
        data = load(sprintf('out-data-gen-%d.mat', i));
        data = data.data;    
        metric_labels = fieldnames(data);
        metric_labels(find(strcmpi(metric_labels, 'POP')), :) = []; % del 'Pop' label
        fit_label_idx = find(strcmpi(metric_labels, 'FIT'));
        if isempty(fit_label_idx)
            fit_label_idx = find(strcmpi(metric_labels, 'FITS'));
        end        
        fits(i, :) = data.(metric_labels{fit_label_idx});
        metric_labels(fit_label_idx, :) = [];

        for ml = 1:length(metric_labels)
            metric_data(i, :, ml) = data.(metric_labels{ml});
        end
    end

    [best_fit, best_fit_idx] = min(fits, [], 2);

    % prepare interesting values
    metric_count = length(metric_labels);
    best_fit_metric = zeros(gen_count, metric_count);
    for i = 1:gen_count
        best_fit_metric(i, :) = metric_data(i, best_fit_idx(i), :);
    end

    figure('Name', extract_fit_title(), 'NumberTitle', 'off');
    subplot(metric_count+1, 1, 1);
    hold on;
    lines = plot(best_fit, 'o', 'MarkerSize',2); labels = "Fitness";
    for i = 1:metric_count
        lines(i+1) = plot(best_fit_metric(:,i), 'o', 'MarkerSize',2); labels(i+1) = metric_labels{i};
    end
    xlim([0 inf]);
    ylim([0 inf]);
    title("Best fitness (and their metric)");
    xlabel("Generation");
    legend(lines, labels);
    hold off

    for mc = 1:metric_count
        subplot(metric_count+1, 1, mc+1);
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

end

function title = extract_fit_title()
    str = pwd;
    idx = strfind(str,'\');
    title = str(idx(end-1)+1:end);
end
