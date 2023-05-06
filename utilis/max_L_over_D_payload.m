function [optimized_params] = max_L_over_D_payload()
% max_L_over_D_payload: A function that maximize the lift over drag ratio
% with internal payload constraint. It uses Convex Optimization cvx Toolbox
% to solve the optimization problem.
%   Inputs:
%       -params: a struct that contains the following fields:
%                       {aoa, M, cl_min, cm_max, c, r, xc, yc,
%                       tau_max, A_min}
%   Outputs:
%       - optimized_params: a vector that contains the optimized values of
%                           the following parameters:
%                              {aoa, a1, a2, b1, b2} - namely the angle of
%                              attack and the upper and lower polynomial
%                              coefficients.
%
% Copyrights Zeyad M. Manaa.
% Code for Paper: Convex optimization scheme for thin airfoils with CFD.

[params] = get_params();

c       = linspace(1,0,20);         % default
aoa     = linspace(0.001,20,30);    % default
theta_a = linspace(0,pi,100);       % default
theta_b = linspace(pi,2*pi,100);    % default
M       = params.M;
A_min   = params.A_min;
r       = params.r;
xc      = params.xc;
yc      = params.yc;
tau_max = params.tau_max;

% OPTIMIZATION REGIEME
for j = 1:length(aoa)
    [x(:,j), lift_to_drag(j)] = opt(aoa(j), M, c, r, ...
        xc, yc, tau_max, A_min);
end

[~, idx]   = max(lift_to_drag);
optimized_params    = x(:,idx);

end


function [x, lift_to_drag] = opt(aoa, M, c, r, ...
    xc, yc, tau_max, A_min)

Q = [1.0 0.0 0.0 0.0 0.0;
    0.0 2/5 3/20 0.0 0.0;
    0.0 3/20 1/15 0.0 0.0;
    0.0 0.0 0.0 2/5 3/20;
    0.0 0.0 0.0 3/20 1/15];

theta_a = linspace(0,pi,100);
theta_b = linspace(pi,2*pi,100);


NO_OF_VARS = 5;


R2D = 180/pi;
D2R = pi/180;

cvx_begin
    variable x(NO_OF_VARS)
    alpha   = x(1);
    a1      = x(2);
    a2      = x(3);
    b1      = x(4);
    b2      = x(5);
    circle_1 = xc + r.*cos(theta_a);
    circle_2 = xc + r.*cos(theta_b);
    
    objective_function   = (x.'*Q*x)/aoa;
    
    minimize( objective_function )
    subject to
    min( -(a1+a2-b1-b2).*c.^3 + (a2-b2).*c.^2 + ...
        (a1-b1).*c ) >= 0;
    
    max( -(a1+a2-b1-b2).*c.^3 + (a2-b2).*c.^2 + ...
        (a1-b1).*c ) <= tau_max;
    
    min((-(a1+a2).*(circle_1).^3) + ...
        (a2.*(circle_1).^2) + ...
        (a1.*(circle_1)) ...
        - yc - r.*sin(theta_a)) >= 0;
    max((-(b1+b2).*(circle_2).^3) + ...
        (b2.*(circle_2).^2) + ...
        (b1.*(circle_2)) ...
        - yc - r.*sin(theta_b)) <= 0;
    
    1/12*(3*a1 + a2 - 3*b1 - b2) >= A_min;
cvx_end

x(1) = aoa*D2R;
lift_to_drag = (x(1))/(x.'*Q*x);

end
