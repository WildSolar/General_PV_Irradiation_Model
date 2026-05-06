%% hemispherePartition.m
% Created by Michael Wild, Version 06.05.2026
% michael.wild@zhaw.ch
%
% Function to obtain a discrete Sky Hemisphere
% The function contains extra outputs that can be re-used in later stages
% of the code for better performance.
%
%% Inputs
% 
% precision     :   Desired Precision Level ('low','medium','high','ultra')
%
%% Outputs
%
% surface_element   :   Vector of discrete sky elements
% areasinelev       :   Projected Area of Sky Elements
% zenithvec         :   Zenith Values of Sky Elements




function[surface_element, areasinelev, zenithvec] = hemispherePartition(precision)

global waitbarhdl;

waitbar(0,waitbarhdl,'Running Sky Discretization')

elev_disc = 0.5;
lower_elevation_deg = 0:elev_disc:(90-elev_disc);
ind = 1;
n_1 = 180;

switch precision
    case 'ultra'
        n_1 = 720;
    case 'high'
        n_1 = 360;
    case 'medium'
        n_1 = 180;
    case 'low'
        n_1 = 90;
end

for (i = 1:length(lower_elevation_deg))
    waitbar(i/length(lower_elevation_deg), waitbarhdl);
    rad = cosd(lower_elevation_deg(i)+0.5);
    n_loco = ceil(n_1*rad)+1;
    az_vec = linspace(0,360, n_loco)+0.25;

    for (j = 1:length(az_vec)-1)
        surface_element{ind}.lower_elevation_deg = lower_elevation_deg(i);
        surface_element{ind}.upper_elevation_deg = lower_elevation_deg(i) + elev_disc;
        surface_element{ind}.elevation_deg = lower_elevation_deg(i) + elev_disc/2;
        surface_element{ind}.lower_azimuth_deg = az_vec(j);
        surface_element{ind}.upper_azimuth_deg = az_vec(j+1);
        surface_element{ind}.azimuth_deg = (az_vec(j) + az_vec(j+1))/2;

        surface_element{ind}.area = cosd((surface_element{ind}.lower_elevation_deg + surface_element{ind}.upper_elevation_deg)/2)*(surface_element{ind}.upper_elevation_deg - surface_element{ind}.lower_elevation_deg)/180*pi*(surface_element{ind}.upper_azimuth_deg - surface_element{ind}.lower_azimuth_deg)/180*pi;                % r^2 sin(zen)d(zen)d(az)

        surface_element{ind}.x = -sind(surface_element{ind}.azimuth_deg)*cosd(surface_element{ind}.elevation_deg);
        surface_element{ind}.y = -cosd(surface_element{ind}.azimuth_deg)*cosd(surface_element{ind}.elevation_deg);
        surface_element{ind}.z = sind(surface_element{ind}.elevation_deg);

        surface_element{ind}.pos = [surface_element{ind}.x, surface_element{ind}.y, surface_element{ind}.z];
        surface_element{ind}.sinelev = sind(surface_element{ind}.elevation_deg);
        surface_element{ind}.areasinelev = surface_element{ind}.sinelev*surface_element{ind}.area;
        surface_element{ind}.zenith_rad = (90 - surface_element{ind}.elevation_deg)/180*pi;

        ind = ind + 1;
    end
end

for i = 1:length(surface_element)
    areasinelev(i) = surface_element{i}.areasinelev;
    zenithvec(i) = surface_element{i}.zenith_rad;
end

