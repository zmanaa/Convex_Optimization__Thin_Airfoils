function [optimized_params, drag] = minimize_supersonic_drag(params)
% minimize_supersonic_drag: A function that minimizes the supersonic drag.
% It uses Convex Optimization cvx Toolbox to solve the optimization problem.
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


% DEFS
R2D = 180/pi;
D2R = pi/180;
NO_OF_VARS = 5;


% RE-EXTRACT PARAMETERS TO BE USED
params = get_params();
c       = linspace(1,0,20);         % default
M       = params.M;
A_min   = params.A_min;


Q = [1.0 0.0 0.0 0.0 0.0;
    0.0 2/5 3/20 0.0 0.0;
    0.0 3/20 1/15 0.0 0.0;
    0.0 0.0 0.0 2/5 3/20;
    0.0 0.0 0.0 3/20 1/15];

%%% OPTIMIZATION REGIEME
cvx_begin
    variable x(NO_OF_VARS)
    alpha   = x(1);
    a1      = x(2);
    a2      = x(3);
    b1      = x(4);
    b2      = x(5);
    q_term  = quad_form(x, Q);
    cost_function   = (4*q_term)/sqrt(M^2 - 1);
    minimize(cost_function);
    subject to     
       min( -(a1+a2-b1-b2).*c.^3 + (a2-b2).*c.^2 + (a1-b1).*c ) >= 0
       1/12*(3*a1 + a2 - 3*b1 - b2) >= A_min
cvx_end

drag = (4*x'*Q*x)/(sqrt(M^2 - 1));
optimized_params = x;
optimized_params(1) = R2D*optimized_params(1); % change alpha from rad to degs
end