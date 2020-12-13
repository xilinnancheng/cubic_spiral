clear all;clc;close all;
% opt.algorithm = NLOPT_LD_MMA;
% opt.lower_bounds = [-inf, 0];
% opt.min_objective = @myfunc;
% opt.fc = { (@(x) myconstraint(x,2,0)), (@(x) myconstraint(x,-1,1)) };
% opt.fc_tol = [1e-8, 1e-8];
% opt.xtol_rel = 1e-4;
% opt.verbose = 1;
% [xopt, fmin, retcode] = nlopt_optimize(opt, [1.234 5.678])
syms x_0 y_0 theta_0
syms x_f y_f theta_f
syms s_t
p = sym('p',[5,1]);
weight = sym('weight',[3,1]);

a0 = p(1);
a1 = -(11 / 2.0 * p(1) - 9 * p(2) + 9 / 2.0 * p(3) - p(4)) / p(5);
a2 = (9 * p(1) - 45 / 2.0 * p(2) + 18 * p(3) - 9 / 2.0 * p(4)) / p(5)^2;
a3 = -(9 / 2.0 * p(1) - 27 / 2.0 * p(2) + 27 / 2.0 * p(3) - 9 / 2.0 * p(4)) / p(5)^3;
sf = p(5);

kappa_s = @(s) a3 * s^3 + a2*s^2 + a1*s + a0;
theta_s = @(s) theta_0 + int(kappa_s(s), [0 s]);

x_simpson = @(x_init, s) x_init + s / 24.0 * (cos(subs(theta_s(s_t),s_t,0)) + 4 * cos(subs(theta_s(s_t),s_t,s/8.0)) + 2 * cos(subs(theta_s(s_t),s_t,s/4.0)) ...
    + 4 * cos(subs(theta_s(s_t),s_t,3.0 * s/8.0)) + 2 * cos(subs(theta_s(s_t),s_t,4.0 * s/8.0)) + 4 * cos(subs(theta_s(s_t),s_t,5.0 * s/8.0)) ...
    + 2 * cos(subs(theta_s(s_t),s_t,6.0 * s/8.0)) + 4 * cos(subs(theta_s(s_t),s_t,7.0 * s/8.0)) + cos(subs(theta_s(s_t),s_t,8.0 * s/8.0)));

y_simpson = @(y_init, s) y_init + s / 24.0 * (sin(subs(theta_s(s_t),s_t,0)) + 4 * sin(subs(theta_s(s_t),s_t,s/8.0)) + 2 * sin(subs(theta_s(s_t),s_t,s/4.0)) ...
    + 4 * sin(subs(theta_s(s_t),s_t,3.0 * s/8.0)) + 2 * sin(subs(theta_s(s_t),s_t,4.0 * s/8.0)) + 4 * sin(subs(theta_s(s_t),s_t,5.0 * s/8.0)) ...
    + 2 * sin(subs(theta_s(s_t),s_t,6.0 * s/8.0)) + 4 * sin(subs(theta_s(s_t),s_t,7.0 * s/8.0)) + sin(subs(theta_s(s_t),s_t,8.0 * s/8.0)));

x_s_f = subs(x_simpson(x_0,s_t),s_t,sf);
y_s_f = subs(y_simpson(y_0,s_t),s_t,sf);
theta_s_f = subs(theta_s(s_t),s_t,sf);

fbe = int(kappa_s(s_t)^2,[0 sf]);
fxf = (x_s_f - x_f)^2;
fyf = (y_s_f - y_f)^2;
ftf = (theta_s_f- theta_f)^2;

fbe_grad = gradient(fbe, p);
fxf_grad = gradient(fxf, p);
fyf_grad = gradient(fyf, p)
ftf_grad = gradient(ftf, p);