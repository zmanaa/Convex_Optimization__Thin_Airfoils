function extract_coords_for_ansys(optimized_coeffs, opt_case)

% Define the x-coordinates for the airfoils
x = linspace(0, 1, 1000);



a1 = optimized_coeffs(2);
a2 = optimized_coeffs(3);
b1 = optimized_coeffs(4);
b2 = optimized_coeffs(5);
y_u = -(a1+a2)*x.^3 + a2*x.^2 + a1*x;
y_l = -(b1+b2)*x.^3 + b2*x.^2 + b1*x;
y_u(1) = 0; y_u(end) = 0;
y_l(1) = 0; y_l(end) = 0;

x = x';
y_u = y_u';
y_l = y_l';

I = ones(length(x), 1);
count = (1:length(x))';
z = zeros(length(x), 1);


A_u = [I count x y_u z];
A_l = [I count x y_l z];

writematrix(A_u,['C:\Users\DELL\Desktop\AE520\Project\' ...
    'airfoil_opt\Opt\Untitled Folder\matlab\' ...
    'Convex-Optimization-Thin-Airfoils\AIRFOIL COORDS\' ...
    'upper_coords_', opt_case, '.txt'],'Delimiter','tab')
writematrix(A_l,['C:\Users\DELL\Desktop\AE520\Project\' ...
    'airfoil_opt\Opt\Untitled Folder\matlab\' ...
    'Convex-Optimization-Thin-Airfoils\AIRFOIL COORDS\' ...
    'lower_coords', opt_case, '.txt'],'Delimiter','tab')

end