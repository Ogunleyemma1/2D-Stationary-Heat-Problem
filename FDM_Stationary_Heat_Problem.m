clc;
clear all;

%% Geometric Parameters for Domain
W = 2;
L = 1;
Nx = 41;
Ny = 21;
dx = W / (Nx - 1);
dy = L / (Ny - 1);

%% Material Properties
k = 50; 

%% Boundary and Initial Conditions
Ti = 0;
T = Ti * ones(Nx, Ny);
T1 = 30; % left
T2 = 10; % right
Q1 = -420; % bottom edge

T(1, :) = T1; % left edge
T(Nx, :) = T2; % right edge

%% Computation
error_history = [];
Epsilon = 1e-5;
Error = 5;

Iter = 0;
while (Error > Epsilon)
    Iter = Iter + 1;
    disp(Iter);
    Told = T;
    for j = 2:Ny-1
        for i = 2:Nx-1
                T(i, j) = (T(i + 1, j) + T(i - 1, j) + T(i, j + 1) + T(i, j - 1)) / (4);
        end
    end

    % Update boundary conditions
    T(2:end-1, 1) = T(2:end-1, 2) + Q1 * dy/k; % Neumann boundary condition Q = -420 W/m^2
    T(2:end-1, end) = T(2:end-1, end-1); % Adiabatic boundary condition Q = 0 W/m^2

    Error = sqrt(sumsqr(T - Told));
    disp(Error);
    error_history = [error_history, Error];
end

%% Plotting the error curve
figure(1);
plot(1:Iter, error_history, '-o');
title('Convergence of Error Over Iterations');
xlabel('Iteration');
ylabel('Error');
grid on;

%% Plotting 2D T result
figure(2);
x = 0:dx:W;
y = 0:dy:L;
colormap(jet);
contourf(x, y, T', 'LineColor', 'None');
colorbar;
title("2D Temperature Values");
xlabel("x-direction");
ylabel("y-direction");

%% Plotting 3D T result
% Different Visualization Approach
figure(3);

% Meshgrid for 3D surface plot
[X_vals, Y_vals] = meshgrid(0:dx:W, 0:dy:L);

% 3D Surface Plot
surf(X_vals, Y_vals, T', 'EdgeColor', 'none');
colormap(jet);
colorbar;

% Title and Labels
title("3D Temperature Values");
xlabel("X-direction");
ylabel("Y-direction");
zlabel("Temperature");

% View Perspective
view(45,30);