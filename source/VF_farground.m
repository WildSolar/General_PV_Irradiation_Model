%% VF_farground.m
% Created by Michael Wild, Version 06.05.2026
% michael.wild@zhaw.ch
%
% Function to obtain the far-ground viewfactor to any point on the panel.
% 
%% Inputs
% 
% chi           : Position on Panel (bounded by -0.5/0.5)
% mu, gamma, rho: Configuration of Array
% simopts       : Simulation Options
%% Outputs
%
% F             : View Factor [-]

function[F] = VF_farground(chi,mu,gamma,rho, simopts)

n_phi = simopts.n_phi;
n_sig = simopts.n_sig;
phi_delim = linspace(-pi/2, pi/2,n_phi+1);
phi_midpoints = (phi_delim(2:end)+phi_delim(1:end-1))/2;
d_phi = phi_delim(2)-phi_delim(1);

F = 0;

for i_phi = 1:length(phi_midpoints)
    sig_bottom = atan((rho*tan(gamma)+(chi-1/2)*sin(mu))/(sqrt((2*cos(mu)*chi-cos(mu)+2*rho)^2*sec(phi_midpoints(i_phi)))/2));
    sig_delim = linspace(0, sig_bottom, n_sig+1);
    sig_midpoints = (sig_delim(2:end)+sig_delim(1:end-1))/2;
    d_sig = sig_delim(2) - sig_delim(1);
    for i_sig = 1:length(sig_midpoints)
        F = F + max(0,1/(2*pi)*(sin(mu)*cos(phi_midpoints(i_phi))*cos(sig_midpoints(i_sig))-(cos(mu)*sin(sig_midpoints(i_sig))))*d_sig*d_phi);
    end
    sigbot(i_phi) = sig_bottom;
end
