%% BuieSolarDistribution.m
% Created by Michael Wild, Version 06.05.2026
% michael.wild@zhaw.ch
%
% Function to obtain a relative luminance distribution near the sun position.
% see:
% D. Buie et al., "Sunshape Distribution for Terrestrial Solar
% Simulations", Solar Energy 74, 2003.
%% Inputs
% 
% CSR           :   Circumsolar Radiation [-] (commonly denoted Chi)
% n_inSun       :   Numerical Precision of Distribution within Sun Disk [-]
% n_outSun      :   Numerical Precision of Distribution outside Sun Disk [-]
%
%% Outputs
%
% phi           :   Vector of angular deviations from  sun position [mrad]
% outDist       :   Normalized distribution of luminance at given phi. [1/sr]
%
function[phi,outDist] = BuieSolarDistribution(CSR,n_inSun,n_outSun)

sunradius = 4.65;        % mrad
phi_solarcircle = linspace(0,sunradius,n_inSun);

outDist(1:n_inSun) = cos(0.326*phi_solarcircle)./cos(0.308*phi_solarcircle);

phi = logspace(log10(sunradius),log10(pi*1e3),n_outSun+1);     % from sunradius to 180° (maximum possible visible)
phi = phi(2:end);

gamma = 2.2*log(0.52*CSR)*CSR^0.43 - 0.1;
kappa = 0.9*log(13.5*CSR)*CSR^(-0.3);

outDist = [outDist, exp(kappa).*phi.^gamma];
phi = [phi_solarcircle, phi];

% total energy 
total_energy = 0;

% numerical integration
for i = 1:length(outDist)-1
    total_energy = total_energy + 2*pi*(outDist(i)*sin(phi(i)*1e-3) + outDist(i+1)*sin(phi(i+1)*1e-3))/2*(phi(i+1)-phi(i))*1e-3; 
end

outDist = outDist/total_energy; % normalization such that total Energy is exactly 1. Can directly be multiplied with DNI later!
