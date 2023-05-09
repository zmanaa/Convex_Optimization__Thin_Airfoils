clear all; clc; close all;

% DEFS
FIG_FOLDER_NAME = 'CFD RESULTS/';
folderName      = ['C:\Users\DELL\Desktop\AE520\Project\airfoil_opt\Opt\' ...
    ['Untitled Folder\matlab\' ...
    'Convex-Optimization-Thin-Airfoils\FIGURES\'] FIG_FOLDER_NAME];
NAME            = 'OPTIMIZED_LD_SUBSONIC';
MACH            = '1-5';

% Read data
cp_neg_2 = table2array(readtable('MACH_15_AOA_NEG_2.xlsx'));
cp_0 = table2array(readtable('MACH_15_AOA_0.xlsx'));
cp_4 = table2array(readtable('MACH_15_AOA_4.xlsx'));
cp_9 = table2array(readtable('MACH_15_AOA_9.xlsx'));
cp_15 = table2array(readtable('MACH_15_AOA_15.xlsx'));

% Figure
fig = figure();

% Figure setup
fig.Units = 'inches';
width_to_height_ratio = 2;
current_position = get(gcf, 'Position');
new_width = current_position(3);
new_height = new_width / width_to_height_ratio;
fig.Position = [current_position(1), current_position(2),...
    new_width new_height];
box on;
hold on;
grid on;

m=4;
cm_magma=plasma(m);
magma_cm = colormap(cm_magma);
set(gca, 'colororder', magma_cm);


plot(cp_0(:,1), cp_0(:,2), 'LineWidth', 1.5); hold on
plot(cp_4(:,1), cp_4(:,2), 'LineWidth', 1.5);
plot(cp_9(:,1), cp_9(:,2), 'LineWidth', 1.5);
plot(cp_15(:,1), cp_15(:,2), 'LineWidth', 1.5);
grid on;
l = legend('$c_p \quad \alpha = 0^{o}$', '$c_p \quad  \alpha = 4^{o}$',...
            '$c_p \quad \alpha = 9^{o}$', '$c_p \quad  \alpha = 15^{o}$',...
            'Location', 'eastoutside', 'Orientation', 'vertical');
set(l, 'interpreter', 'latex')
set(l, 'box', 'off')


ax1 = gca;
ax1.XAxis.MinorTick = 'on';
ax1.YAxis.MinorTick = 'on';
ax1.YDir = 'reverse';   
set(gca,'TickLabelInterpreter','latex','fontsize',10);


% Save the figure
print('-dpng', '-painters', '-cmyk', '-loose', ...,
    [folderName, 'PRESSURE_COEF', NAME, '_', MACH, '.png']);