function plot_airfoil(optimized_coeffs, case_string)
%PLOT_AIRFOIL Plots an airfoil parametrized by a third degree polynomial and
%compares it to an original airfoil.
%
%   Inputs:
%   - optimized_coeffs
%
%   Outputs:
%   - None (saves the figure as an .eps file in the FIGURES folder).

addpath("utilis\colormaps\")

%%% DEFS
FIG_FOLDER_NAME = 'OPTIMIZATION/';
folderName      = ['FIGURES/' FIG_FOLDER_NAME];
TYPE            = case_string;


%%% Making a directory for figures
if ~exist(folderName, 'file') % check if folder doesn't exist
    mkdir(folderName); % create the folder
end


%%% Check payload plotting
if ismember(TYPE, {'max_L_over_D_payload', ...
        'max_L_over_D_payload_subsonic_const'})
    PAYLOAD_FLAG = 1;
else
    PAYLOAD_FLAG = 0;
end

% Define the x-coordinates for the airfoils
x = linspace(0, 1, 1000);


% Create the figure and subplot layout
fig = figure();


% Colormap
m=3;
cm_magma=viridis(m);
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


% Plot the optimized airfoil
a1 = optimized_coeffs(2);
a2 = optimized_coeffs(3);
b1 = optimized_coeffs(4);
b2 = optimized_coeffs(5);
y_u = -(a1+a2)*x.^3 + a2*x.^2 + a1*x;
y_l = -(b1+b2)*x.^3 + b2*x.^2 + b1*x;
y_u(1) = 0; y_u(end) = 0;
y_l(1) = 0; y_l(end) = 0;
plot(x, y_u, 'LineWidth', 2);
plot(x, y_l, 'LineWidth', 2);


% Set the axis labels and title
xlabel('x/c (m)', 'Interpreter', 'latex');
ylabel('y/c (m)', 'Interpreter', 'latex');


% Add minor ticks to the x and y axes
ax1 = gca;
ax1.XAxis.MinorTick = 'on';
ax1.YAxis.MinorTick = 'on';
set(gca,'TickLabelInterpreter','latex','fontsize',10);


[params] = get_params();
% Plot payload
if PAYLOAD_FLAG
    hold on
    th = 0:pi/50:2*pi;
    xunit = params.r * cos(th) + params.xc;
    yunit = params.r * sin(th) + params.yc;
    plot(xunit, yunit,'LineWidth',2);
end


if PAYLOAD_FLAG
    l = legend('upper surface','lower surface','payload', ...
        'Interpreter','latex', ...
        'Location', 'eastoutside', ...
        'Orientation', 'vertical');
    set(l,'box', 'off')
else
    legend('upper surface','lower surface', ...
        'Interpreter','latex', ...
        'Location', 'eastoutside', ...
        'Orientation', 'vertical');
    set(l,'box', 'off')
end


axis padded


% Save the figure
print('-dpdf', '-painters', '-cmyk', '-loose', ...,
    [folderName, 'OPTIMIZE_AIRFOIL_',  TYPE, '.pdf']);
end