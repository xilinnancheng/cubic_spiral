clear; clc;
addpath(genpath('../../functions'));

%%
x_0 = [0; 0; 0; 0];
x_f = [5; 2; 0; 0];
kappa_max = 0.2;

p = sym('p', [5,1]);    % [kappa_.33, kappa_.67, s_f]
syms s x_init theta_init x_final;

p_var = [p(1); p(2); p(4)];

a_0 = p(1);
a_1 = -(11*p(1)/2 - 9*p(2) + 9*p(3)/2 - p(4))/p(5);
a_2 = (9*p(1) - 45*p(2)/2 + 18*p(3) - 9*p(4)/2)/p(5)^2;
a_3 = -(9*p(1)/2 - 27*p(2)/2 + 27*p(3)/2 - 9*p(4)/2)/p(5)^3;
s_f = p(5);

% syms s a_0 a_1 a_2 a_3 s_f;

kappa_s = @(s) a_3 * s^3 + a_2 * s^2 + a_1 * s + a_0;
psi_s = @(psi_0, s) psi_0 + int(kappa_s(s), [0, s]);

% 8-segment simpson's rule
x_s = @(x_0, psi_0, s) x_0 + s/24 * (cos(psi_s(psi_0,0)) + 4*cos(psi_s(psi_0,s/8)) + 2*cos(psi_s(psi_0,2*s/8)) + 4*cos(psi_s(psi_0,3*s/8)) + 2*cos(psi_s(psi_0,4*s/8)) + 4*cos(psi_s(psi_0,5*s/8)) + 2*cos(psi_s(psi_0,6*s/8)) + 4*cos(psi_s(psi_0,7*s/8)) + cos(psi_s(psi_0,s)));
y_s = @(y_0, psi_0, s) y_0 + s/24 * (sin(psi_s(psi_0,0)) + 4*sin(psi_s(psi_0,s/8)) + 2*sin(psi_s(psi_0,2*s/8)) + 4*sin(psi_s(psi_0,3*s/8)) + 2*sin(psi_s(psi_0,4*s/8)) + 4*sin(psi_s(psi_0,5*s/8)) + 2*sin(psi_s(psi_0,6*s/8)) + 4*sin(psi_s(psi_0,7*s/8)) + sin(psi_s(psi_0,s)));
x_s_f = subs(x_s(x_init, theta_init, s), s, s_f);
y_s_f = subs(y_s(x_0(2), x_0(3), s), s, s_f);

% n_disc = 8;
% ds = (s - s_0) / n_disc;
% syms x_0_sym y_0_sym psi_0;
% x_s_sym = x_0_sym;
% y_s_sym = y_0_sym;
% 
% % simpson's rule
% for i = 0 : n_disc
%   if i == 0 || i == n_disc
%     x_s_sym = x_s_sym + ds/3*cos(psi_s(psi_0,i*ds));
%     y_s_sym = y_s_sym + ds/3*sin(psi_s(psi_0,i*ds));
%   elseif mod(i, 2) == 1   % odd
%     x_s_sym = x_s_sym + 4*ds/3*cos(psi_s(psi_0,i*ds));
%     y_s_sym = y_s_sym + 4*ds/3*sin(psi_s(psi_0,i*ds));
%   else                    % even
%     x_s_sym = x_s_sym + 2*ds/3*cos(psi_s(psi_0,i*ds));
%     y_s_sym = y_s_sym + 2*ds/3*sin(psi_s(psi_0,i*ds));
%   end
% end

% % trapezoidal rule
% for i = 0 : (n_disc - 1)
%   x_s_sym = x_s_sym + (cos(psi_s(psi_0,i*ds))+cos(psi_s(psi_0,(i+1)*ds)))*ds/2;
%   y_s_sym = y_s_sym + (sin(psi_s(psi_0,i*ds))+sin(psi_s(psi_0,(i+1)*ds)))*ds/2;
% end
% x_s = matlabFunction(x_s_sym, 'vars', [x_0_sym; psi_0; s; p]);
% y_s = matlabFunction(y_s_sym, 'vars', [y_0_sym; psi_0; s; p]);
% x_s_f = x_s(x_0(1), x_0(3), s_f, p(2), p(3), p(5));
% y_s_f = y_s(x_0(2), x_0(3), s_f, p(2), p(3), p(5));

psi_s_f = subs(psi_s(x_0(3), s), s, s_f);
kappa_s_f = subs(kappa_s(s), s, s_f);

cost_bending = int(kappa_s(s)^2, [0 s_f]);

%%
filename_cost_bending = 'compute_cost_bending.m';
matlabFunction(cost_bending, 'vars', p, 'file',filename_cost_bending);

% convert subscripts in costs
char_to_converrt = {'p'};
for i = 1 : length(char_to_converrt)
  system(['sed -i "s#',char_to_converrt{i},'\([0-9]\+\)#',char_to_converrt{i},'(\1)#g" ', filename_cost_bending]);
end

%% solve the optimization problem
w_x = 1e5;
w_y = 1e5;
w_psi = 1e5;

(x_s_f - x_final)^2
% cost = int(kappa_s(s)^2, [0 s_f]);
cost = int(kappa_s(s)^2, [0 s_f]) + ...
           w_x * (x_s_f - x_f(1))^2 + ...
           w_y * (y_s_f - x_f(2))^2 + ...
           w_psi * (psi_s_f - x_f(3))^2;
J_cost = jacobian(cost, p).';
H_cost = jacobian(J_cost, p);