% load data - set correct values before running
data_folder = 'logs/737176832';
gen_count = 219;

collis = []; dists = []; fits = [];

% load data
for i = 1:gen_count
    %collisions
    mat = load(sprintf('%s/collisions-gen-%d.mat', data_folder, i));
    collis = [collis; mat.collis];
    
    %distances
    mat = load(sprintf('%s/distances-gen-%d.mat', data_folder, i));
    dists = [dists; mat.dists];
    
    % fitnesses
    mat = load(sprintf('%s/fit-gen-%d.mat', data_folder, i));
    fits = [fits; mat.Fit];
end

[best_fit, best_fit_idx] = min(fits, [], 2);

% prepare interesting values
best_collis = zeros(gen_count, 1);
best_dists = zeros(gen_count, 1);
for i = 1:gen_count
    best_collis(i) = collis(i, best_fit_idx(i));
    best_dists(i) = dists(i, best_fit_idx(i));
end

figure; 
hold on;
subplot(3, 1, 1);
hold on;
line1 = plot(best_fit, 'og', 'MarkerSize',2); label1 = "Fitness";
line2 = plot(best_collis, 'or', 'MarkerSize',2); label2 = "Collisions";
line3 = plot(best_dists, 'ob', 'MarkerSize',2); label3 = "Distances";
xlim([0 inf]);
ylim([0 inf]);
title("Best fitness (and their Collision count and Distance)");
xlabel("Generation");
legend([line1, line2, line3], [label1, label2, label3]);

subplot(3, 1, 2);
hold on;
line1 = plot(mean(collis, 2), 'og', 'MarkerSize',2); label1 = "mean";
line2 = plot(max(collis, [], 2), 'ob', 'MarkerSize', 2); label2 = "max";
line3 = plot(min(collis, [], 2), 'or', 'MarkerSize',2); label3 = "min";
xlim([0 inf]);
ylim([0 inf]);
title("Collision count");
xlabel("Generation");
legend([line1 line2 line3], [label1 label2 label3]);

subplot(3, 1, 3);
hold on;
line1 = plot(mean(dists, 2), 'og', 'MarkerSize',2); label1 = "mean";
line2 = plot(max(dists, [], 2), 'ob', 'MarkerSize', 2); label2 = "max";
line3 = plot(min(dists, [], 2), 'or', 'MarkerSize',2); label3 = "min";
xlim([0 inf]);
ylim([0 inf]);
title("Distance to target");
xlabel("Generation");
legend([line1 line2 line3], [label1 label2 label3]);