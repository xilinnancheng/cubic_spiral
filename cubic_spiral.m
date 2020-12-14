clear all;clc;close all;
%% start point
x0 = 0.0;
y0 = 0.0;
theta0 = 0.0;
k0 = 0.0;
start = [x0,y0,theta0,k0];

%% target point
xf = 15.0;
yf = 10.0;
thetaf = 0.5 * pi;
kf = 0.0;

%% parameter
delta_x = 0.3;
delta_y = 0.0;
num = 2;

%% main loop
for main_loop_index = -num:1:num
    xf_tmp = xf + main_loop_index * delta_x;
    yf_tmp = yf + main_loop_index * delta_y;
    thetaf_tmp = thetaf;
    kf_tmp = kf;
    target = [xf_tmp,yf_tmp,thetaf_tmp,kf_tmp];

    lower_bound = -0.2;
    upper_bound = 0.2;

    p_optimize = spiral_optimize(lower_bound,upper_bound,start,target);

    p = [k0,p_optimize(1),p_optimize(2),kf,p_optimize(3)];

    a0 = p(1);
    a1 = -(11 / 2.0 * p(1) - 9 * p(2) + 9 / 2.0 * p(3) - p(4)) / p(5);
    a2 = (9 * p(1) - 45 / 2.0 * p(2) + 36 / 2.0 * p(3) - 9 / 2.0 * p(4)) / p(5)^2;
    a3 = -(9 / 2.0 * p(1) - 27 / 2.0 * p(2) + 27 / 2.0 * p(3) - 9 / 2.0 * p(4)) / p(5)^3;
    sf = p(5);

    syms s_t
    kappa_s = @(s) a3 * s.^3 + a2*s.^2 + a1*s + a0;
    theta_s = @(s) theta0 + integral(kappa_s, 0,s);

    figure(1);
    s_sampled = 0:0.1:sf;
    kappa = kappa_s(s_sampled);
    subplot(2,1,1);
    plot(s_sampled,kappa);grid on;hold on;
    title("Curvature")

    theta = zeros(1,size(s_sampled,2));
    for index = 1:size(theta,2)
        theta(index) = theta_s(s_sampled(index));
    end
    subplot(2,1,2);
    plot(s_sampled,theta);grid on;hold on;
    title("Theta")

    figure(2);
    x = zeros(1,size(s_sampled,2));
    y = zeros(1,size(s_sampled,2));

    x_simpson = @(x_init, s) x_init + s / 24.0 * (cos(theta_s(0)) + 4 * cos(theta_s(s/8.0)) + 2 * cos(theta_s(2.0 *s/8.0)) ...
        + 4 * cos(theta_s(3.0 *s/8.0)) + 2 * cos(theta_s(4.0 *s/8.0)) + 4 * cos(theta_s(5.0 *s/8.0)) ...
        + 2 * cos(theta_s(6.0 *s/8.0)) + 4 * cos(theta_s(7.0 *s/8.0)) + cos(theta_s(8.0 *s/8.0)));

    y_simpson = @(y_init, s) y_init + s / 24.0 * (sin(theta_s(0)) + 4 * sin(theta_s(s/8.0)) + 2 * sin(theta_s(2.0 *s/8.0)) ...
        + 4 * sin(theta_s(3.0 *s/8.0)) + 2 * sin(theta_s(4.0 *s/8.0)) + 4 * sin(theta_s(5.0 *s/8.0)) ...
        + 2 * sin(theta_s(6.0 *s/8.0)) + 4 * sin(theta_s(7.0 *s/8.0)) + sin(theta_s(8.0 *s/8.0)));

    for index = 1:size(x,2)
        x(index) = x_simpson(x0,s_sampled(index));
        y(index) = y_simpson(y0,s_sampled(index));
    end
    plot(x,y);grid on;hold on;
    title('position');
end