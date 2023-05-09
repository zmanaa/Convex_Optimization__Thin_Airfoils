clear all; clc; close all;


% DEFS
FIG_FOLDER_NAME = 'CFD VALIDATION/';
folderName      = ['C:\Users\DELL\Desktop\AE520\Project\airfoil_opt\Opt\' ...
    ['Untitled Folder\matlab\' ...
    'Convex-Optimization-Thin-Airfoils\FIGURES\'] FIG_FOLDER_NAME];
NAME            = 'NACA0015';
CASE            = 'CP_VALIDATION';

A = readtable('NACA0015_extracted_experimental_data.xlsx');
A_numerical = readtable('NACA0015_numerical_cp.xlsx');

A = table2array(A);
A_numerical = table2array(A_numerical);

fig = figure();

m=3;
cm_magma=plasma(m);
magma_cm = colormap(cm_magma);
set(gca, 'colororder', magma_cm);

set(gca,'XMinorTick','on','YMinorTick','on');
fig.Units = 'inches';
width_to_height_ratio = 1.7;
current_position = get(gcf, 'Position');
new_width = current_position(3);
new_height = new_width / width_to_height_ratio;
fig.Position = [current_position(1), current_position(2),...
    new_width new_height];
box on;
hold on;
grid on;
axis tight
c = A_numerical(:,2);
sz = 25;
scatter(A_numerical(:,1), A_numerical(:,2),sz, 's', 'filled'); hold on
scatter(A(:,1), A(:,2), sz, '^', 'filled'); hold on
scatter(A(:,3), A(:,4), sz, 'v', 'filled');
xlabel('$x/c$', 'interpreter', 'latex', 'FontSize', 14)
ylabel('$c_p$', 'interpreter', 'latex', 'FontSize', 14)

l = legend( 'CFD', 'experimental upper surface', ...
    'experimental lower surface', 'Location', 'eastoutside',...
    'Orientation', 'vertical');
set(l, 'box', 'off');
set(l, 'interpreter', 'latex');


set(gca, 'YDir','reverse')

% Save the figure
print('-dpng', '-painters', '-cmyk', '-loose', ...,
    [folderName, 'PRESSURE_COEF', NAME, '_', CASE, '.png']);