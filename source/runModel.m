%% runModel.m
% Created by Michael Wild, Version 06.05.2026
% michael.wild@zhaw.ch
%
% Main Handler Function to Execute the Model.
% See ../example_script.m for details on the contents of the various input
% and output objects.
% 
%% Inputs
% 
% configuration :   Struct containing the geometric configuration of the problem.
% irradiation   :   (Vector of) struct containing the irradiation specification.
% simopts       :   Struct containing simulation options.
%
%% Outputs
%
% results       :   Struct containing all model outputs.
%

function[results] = runModel(configuration, irradiation, simopts)

if ~exist('output')
    mkdir('output');
end

mu = configuration.mu_deg/180*pi;
gamma = configuration.gamma_deg/180*pi;
alpha_g = configuration.alpha_g_deg/180*pi;
gamma_fg = configuration.gamma_fg_deg/180*pi;
alpha_fg = configuration.alpha_fg_deg/180*pi;

chi_vec = linspace(-0.5, 0.5, simopts.n_chi + 1);
sigma_vec = linspace(0,180, simopts.n_sigma + 1)/180*pi;

global waitbarhdl
waitbarhdl = waitbar(0, 'Running');

MultiTable = buildMultiplicationTable(mu,configuration.rho_bar,gamma,configuration.h_bar,chi_vec,sigma_vec, simopts);
[sky_elements, areasinelev, zenithvec] = hemispherePartition(simopts.hemispherePrecision);
for i = 1:length(irradiation.DNI)
    waitbar(i/length(irradiation.DNI),waitbarhdl, 'Running Irradiation Simulation');
    sunposition.azimuth = irradiation.sunposition.azimuth_deg(i)/180*pi;
    sunposition.zenith = pi/2 - irradiation.sunposition.elevation_deg(i)/180*pi;
    radiationMap = totalSkyLuminance(sky_elements,irradiation.DNI(i),irradiation.GHI(i),sunposition,areasinelev,zenithvec);
    results{i} = applyMultiplicationTable(MultiTable, radiationMap, sky_elements, irradiation.omega(i), irradiation.omega_fg(i), configuration);
    results{i}.runInfo.mu_deg = configuration.mu_deg;
    results{i}.runInfo.gamma_deg = configuration.gamma_deg;
    results{i}.runInfo.rho_bar =configuration.rho_bar;
    results{i}.runInfo.h_bar = configuration.h_bar;
    results{i}.runInfo.omega = irradiation.omega(i);
    results{i}.runInfo.omega_fg = irradiation.omega_fg(i);
    results{i}.runInfo.alpha_g_deg = configuration.alpha_g_deg;
    results{i}.runInfo.DNI = irradiation.DNI(i);
    results{i}.runInfo.GHI = irradiation.GHI(i);
    results{i}.runInfo.sunposition = sunposition;
    results{i}.runInfo.chi_vec = chi_vec;
    results{i}.runInfo.name = simopts.name;
    if simopts.savePlots
    visualizeResult(results{i}, num2str(i));
    end
end
close(waitbarhdl);
