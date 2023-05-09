function [optimized_params, cost_function] = solve_optimization(opt_case)
% solve_optimization: a function that selects and calls a specific 
% optimization function based on the given case string. 
%   Inputs:
%       - opt_case: a string that specifies which optimization 
%                    function to call. The case string for now should take
%                    only these cases:
%                         {'min_supersonic_drag',
%                          'max_L_over_D_payload',
%                          'max_L_over_D_payload_subsonic_const'}.
%
%   Outputs:
%       - optimized_params: the optimized output parameters obtained 
%                           from the called function. 
%                              {aoa, a1, a2, b1, b2} - namely the angle of
%                              attack and the upper and lower polynomial
%                              coefficients.
% Copyrights Zeyad M. Manaa. 
% Code for Paper: Convex optimization scheme for thin airfoils with CFD.


% Define the function handles for each case
functionHandles = containers.Map;
functionHandles('min_supersonic_drag') = @minimize_supersonic_drag;
functionHandles('max_L_over_D_payload') = @max_L_over_D_payload;
functionHandles('max_L_over_D_payload_subsonic_const') = ...
                                @max_L_over_D_payload_subsonic_with_constr;


% Call the appropriate function based on the case string
if functionHandles.isKey(opt_case)
    func = functionHandles(opt_case);
    [optimized_params, cost_function] = func();
else
    error('Invalid case string');
end

end