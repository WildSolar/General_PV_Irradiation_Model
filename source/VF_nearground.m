%% VF_nearground.m
% Created by Michael Wild, Version 06.05.2026
% michael.wild@zhaw.ch
%
% Function to obtain the viewfactor from an area bounded by d1 and d2 to a
% position on the panel P(chi).
%
%% Inputs
% 
% chi           : Position on the Panel (bounded by -0.5/0.5)
% d1,d2         : Area Boundary of the Ground [-]
% mu, gamma, hr : Configuration of the array
% n_d, n_u      : Numerical Precision Parameters
%
%% Outputs
%
% F             : View Factor [-]
%
function [F] = VF_nearground(chi, d1, d2, mu, gamma, hr, n_d, n_u)

if d1 == d2
    F = 0;
    return
end

n_d = ceil(n_d/(1+abs(min(d1,d2))));


d_vec = linspace(d1,d2, n_d+1);
u_vec = linspace(-pi/2, pi/2, n_u+1);
u = 0.5*(u_vec(1:end-1)+u_vec(2:end));
d_u = pi/n_u;
d = 0.5*(d_vec(1:end-1)+d_vec(2:end));
d_d = (d2-d1)/n_d;

[D, U] = meshgrid(d, u);
dA = d_u*ones(n_u,1).*(d_d*ones(1,n_d));

numint = 1/pi*(1+tan(U).^2).*(hr*cos(mu) - D*sin(gamma-mu)).*(chi*sin(mu-gamma)+hr*cos(gamma))./(D.^2+chi^2-2*D*chi*cos(gamma-mu)+hr^2+tan(U).^2-2*hr*(D*sin(gamma)-chi*sin(mu))).^2.*dA;

F = sum(sum(numint));

