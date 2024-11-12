%% Laden der Daten
data = load("genderData.mat");
height_m = data.height_m_in_cm;
height_f = data.height_f_in_cm;
weight_m = data.weight_m_in_kg;
weight_f = data.weight_f_in_kg;
    
%% Schätzung der Parameter der Verteilungen

mu_hm = mean(height_m);
mu_hf = mean(height_f);
mu_wm = mean(weight_m);
mu_wf = mean(weight_f);
mu_m = [mu_hm mu_wm];
mu_f = [mu_hf mu_wf];


var_hm = var(height_m);
var_hf = var(height_f);
var_wm = var(weight_m);
var_wf = var(weight_f);

cov_m = cov(height_m, weight_m);
cov_f = cov(height_f, weight_f);
    
%% Darstellung der geschätzen Verteilungen
vals_height = 140:200;
mh_prob = mvnpdf(vals_height', mu_hm, var_hm);
fh_prob = mvnpdf(vals_height', mu_hf, var_hf);

vals_weight = 40:100;
mw_prob = mvnpdf(vals_weight', mu_wm, var_wm);
fw_prob = mvnpdf(vals_weight', mu_wf, var_wf);

[grid_h, grid_w] = meshgrid(vals_height, vals_weight);
grid = [grid_h(:) grid_w(:)];
contour_vals_m = mvnpdf(grid, mu_m, cov_m);
contour_vals_m = reshape(contour_vals_m, size(grid_h));
contour_vals_f = mvnpdf(grid, mu_f, cov_f);
contour_vals_f = reshape(contour_vals_f, size(grid_h));

figure;
subplot(2,2,1);
hold on;
plot(vals_height, mh_prob);
plot(vals_height, fh_prob);
hold off;

subplot(2, 2, 2);
hold on;
plot(vals_weight, mw_prob);
plot(vals_weight, fw_prob);
hold off;

subplot(2, 2, 3);
hold on;
contour(grid_h, grid_w, contour_vals_m, "b");
contour(grid_h, grid_w, contour_vals_f, "r");
hold off;

subplot(2, 2, 4);
surf(grid_h, grid_w, contour_vals_m, 'FaceColor', 'blue', 'EdgeColor', 'none');
hold on;
surf(grid_h, grid_w, contour_vals_f, 'FaceColor', 'red', 'EdgeColor', 'none');
hold off;

%% Naiver Bayes Klassifikator
%  Variablen unabhängig, eindimensionale Normalverteilungen

hm = mvnpdf(182, mu_hm, var_hm);
wm = mvnpdf(182, mu_wm, var_wm);
pred_m = hm * wm;
hf = mvnpdf(79, mu_hf, var_hf);
wf = mvnpdf(79, mu_wf, var_wf);
pred_f = hf * wf;
[~, idx] = max([pred_m pred_f]);
disp(idx);

hm = mvnpdf(188, mu_hm, var_hm);
wm = mvnpdf(188, mu_wm, var_wm);
pred_m = hm * wm;
hf = mvnpdf(130, mu_hf, var_hf);
wf = mvnpdf(130, mu_wf, var_wf);
pred_f = hf * wf;
[~, idx] = max([pred_m pred_f]);
disp(idx);

hm = mvnpdf(195, mu_hm, var_hm);
wm = mvnpdf(195, mu_wm, var_wm);
pred_m = hm * wm;
hf = mvnpdf(95, mu_hf, var_hf);
wf = mvnpdf(95, mu_wf, var_wf);
pred_f = hf * wf;
[~, idx] = max([pred_m pred_f]);
disp(idx);
   
%% Bayes Klassifikator
%  Variablen abhängig, mehrdimensionale Normalverteilung

pred = [mvnpdf([182 79], mu_m, cov_m), mvnpdf([182 79], mu_f, cov_f)];
[~, idx] = max(pred);
disp(idx);

pred = [mvnpdf([188 130], mu_m, cov_m), mvnpdf([188 130], mu_f, cov_f)];
[~, idx] = max(pred);
disp(idx);

pred = [mvnpdf([195 95], mu_m, cov_m), mvnpdf([195 95], mu_f, cov_f)];
[~, idx] = max(pred);
disp(idx);
