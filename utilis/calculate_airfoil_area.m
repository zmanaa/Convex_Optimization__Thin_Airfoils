clear all; clc; close all;

addpath('AIRFOIL COORDS\');

filename = '64a210.xlsx';
A = readmatrix(filename);

x_u = flip(A(:,1)/100);
y_u = flip(A(:,2)/100);
x_l = (A(:,3)/100);
y_l = (A(:,4)/100);

fig = figure();


% Colormap
m=3;
cm_magma=plasma(m);
magma_cm = colormap(cm_magma);
set(gca, 'colororder', magma_cm);


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
axis equal;
ylim([-0.2 0.2])
xlim([-0.1 1.1])


plot(x_u, y_u, x_l, y_l,'LineWidth',1.5)
xlabel('$x/c$', 'Interpreter', 'latex');
ylabel('$y/c$', 'Interpreter', 'latex');

ax1 = gca;
ax1.XAxis.MinorTick = 'on';
ax1.YAxis.MinorTick = 'on';
set(gca,'TickLabelInterpreter','latex','fontsize',10);

l = legend('upper surface','lower surface', ...
    'Interpreter','latex', ...
    'Location', 'eastoutside', ...
    'Orientation', 'vertical');
set(l,'box', 'off')

axis padded


FIG_FOLDER_NAME = 'OPTIMIZATION/';
folderName      = ['C:\Users\DELL\Desktop\AE520\Project\airfoil_opt\Opt\' ...
    ['Untitled Folder\matlab\Convex-Optimization-Thin-Airfoils\' ...
    'FIGURES\'] FIG_FOLDER_NAME];
TYPE            = 'ORIGINAL';
NAME            = 'NACA64a210';

print('-dpng', '-painters', '-cmyk', '-loose', ...,
    [folderName, TYPE, '_', NAME, '.png']);

area = trapz(x_u, y_u) + abs(trapz (x_l, y_l));