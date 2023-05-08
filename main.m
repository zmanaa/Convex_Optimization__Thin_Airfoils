% Instructions:
%   1 - in the command window type 'cd cvx'.
%   2 - then thype 'cvx_setup' and wait until the setup finishes.
%   3 - then run the 'main.m' file.
%
% Copyrights Zeyad M. Manaa.
% Code for Paper: Convex optimization scheme for thin airfoils with CFD.

clear all; clc; close all;

addpath("utilis\")

 
% getting flight condition parameters.
[params] = get_params();


% choosing the optimization case
opt_case = 'min_supersonic_drag';
%opt_case = 'max_L_over_D_payload';
%opt_case = 'max_L_over_D_payload_subsonic_const';


% solve the optimization problem
[optimized_params] = solve_optimization(opt_case);


% plot airfoil
plot_airfoil(optimized_params, opt_case);

% extract coordinates 
extract_coords_for_ansys(optimized_params, opt_case)