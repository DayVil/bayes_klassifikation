clear all;
close all;
clc;

%% Bestimme ("ideale") Zellmaske

% Beispielbilder laden und als (dreidimensionale) Matrix abspeichern
dir = './Good/';
n_img = 150;

pos_images = [];
for im = 1:n_img
    filename = cat(2, dir, 'Good', num2str(im), '.bmp');
    if exist(filename, 'file')
        pos_images = cat(3, pos_images, im2double(imread(filename)));
    end
end


% Bestimmung einer "durchschnittlichen" Zelle aus den Beispielbildern
% Hinweis: imadjust kann den Kontrast in diesem Bild verbessern


% TODO

mean_cell = mean(pos_images, 3);
mean_cell = imadjust(mean_cell);

% Histogramm bestimmen
% Befehl: imhist


% TODO
figure;
imhist(mean_cell);


% Schwellwerte aus Histogramm bestimmen (manuell oder automatisch) und
% Zellen-Labelbild aus der Durchschnittszelle definieren, z.B.
% Wert  1 - Zellkern (helle Bereiche)
% Wert -1 - Zellwand (dunkle Bereiche)
% Wert  0 - übrige Bereiche


% TODO
c_min = 0.45;
c_max = 0.55;
cell_mask(mean_cell > c_max) = 1;
cell_mask(mean_cell < c_min) = -1;
cell_mask(mean_cell >= c_min & mean_cell <= c_max) = 0;

%% Bestimmung der Verteilungsfunktionen
%  Als Merkmal wird die Differenz des mittleren Grauwerts von Zellkern und
%  Zellwand verwendet. Es wird die Annahme getroffen dieses Merkmal ist
%  normalverteilt.

% Merkmal für die positiven Beispiele bestimmen, d.h. in jedem Beispielbild
% wird der Mittelwert im Bereich des Zellkerns und der Zellwand bestimmt
% und abschließend voneinander abgezogen.
% Die entsprechenden Bereiche sind durch die definierte Zellmaske gegeben.

good_features = zeros(1, size(pos_images, 3));
for it = 1:size(pos_images, 3)
    im = pos_images(:, :, it);
    
    % TODO
    nucleus_mean = mean(im(cell_mask == 1));
    wall_mean = mean(im(cell_mask == -1));
    good_features(it) = nucleus_mean - wall_mean;
end

% Bestimme Mittelwert und Varianz der postiven Beispiele


% TODO
mu = mean(good_features);
sigma = var(good_features);
std_pos = std(good_features);


% Merkmal für die negativen Beispiele bestimmen.
dir = './Bad/';
n_img = 460;

neg_images = [];
for im = 1:n_img
    filename = cat(2, dir, 'Bad', num2str(im), '.bmp');
    if exist(filename, 'file')
        neg_images = cat(3, neg_images, im2double(imread(filename)));
    end
end


bad_features = zeros(1, size(neg_images, 3));
for it = 1:size(neg_images, 3)
    im = neg_images(:, :, it);

    
    % TODO
    nucleus_mean = mean(im(cell_mask == 1));
    wall_mean = mean(im(cell_mask == -1));
    bad_features(it) = nucleus_mean - wall_mean;
end

% Bestimme Mittelwert und Varianz der negativen Beispiele


% TODO
mu_bad = mean(bad_features);
sigma_bad = var(bad_features);
std_bad = std(bad_features);

%% Schwellwert für die Klassifikation bestimmen

% Verteilungen (positive und negative Beispiele) plotten


% TODO
figure;
hold on;
histogram(good_features);
histogram(bad_features);



% Schwellwert bestimmen, der eine (optimale) Trennung zwischen Zelle und
% Hintergrund auf der Basis des Merkmals angibt und im Plot markieren


    % TODO

threshold = (mu * std_bad + mu_bad * std_pos) / (std_pos + std_bad);
xline(threshold, "green");
hold off;

%% Bild(ausschnitte) klassifizieren und gefundene Zellen markieren

% Testbild laden
img = im2double(rgb2gray(imread('CellDetectPreFreeze.jpg')));


% Bild mit einem "Sliding Window" absuchen und Zellen über die Differenz des
% mittleren Grauwerts der maskierten Zellbestandteile und den Schwellwert detektieren.
% Zur Beschleunigung ist es ausreichend, das Fenster in 5er-Schritten weiterzuschieben.

    
% TODO
%% Classify test image
[rows, cols] = size(img);
window_size = size(mean_cell);
step_size = 5;

h = figure;
ax = axes(h);
imshow(img, 'Parent', ax);
hold(ax, 'on');
for i = 1:step_size:rows-window_size(1)
    for j = 1:step_size:cols-window_size(2)
        window = img(i:i+window_size(1)-1, j:j+window_size(2)-1);
        nucleus_mean = mean(window(cell_mask == 1));
        wall_mean = mean(window(cell_mask == -1));
        feature = nucleus_mean - wall_mean;

        if feature > threshold
            % rectangle('Position', [j, i, window_size(2), window_size(1)], 'EdgeColor', 'r');
            plot(ax, j + (window_size(1) / 2), i + (window_size(2) / 2), 'rp', 'MarkerFaceColor','g');
        end
    end
end
hold(ax, 'off');

% Bild und gefundene Zellen darstellen


% TODO
% Display results