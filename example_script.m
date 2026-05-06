


%% Geometric Configuration of the Scene
% Single Configuration needs to be specified
configuration.mu_deg = 60;                                      % Panel Inclination [deg]
configuration.gamma_deg = 20;                                   % Ground Slope [deg]
configuration.alpha_g_deg = 0;                                  % Ground Azimuth [deg] (0° = South, 90° = West)
configuration.rho_bar = 1.125;                                  % Non-Dimensional Horizontal Rowspacing [-]
configuration.h_bar = 1.84;                                     % Non-Dimensional Panel Center Height [-]
configuration.gamma_fg_deg = 20;                                % Far-Ground Characteristic Ground Slope [deg]
configuration.alpha_fg_deg = 160;                               % Far-Ground Characteristic Ground Azimuth [deg]

%% Simulation Options

simopts.name = 'test2';                                         % Project Name
simopts.savePlots = 1;                                          % Option to Save Plots (/output/simname)
simopts.n_chi = 100;                                            % Number of Discrete Panel Elements
simopts.n_sigma = 180;                                          % Number of Discrete Projected Sky Point Elevations
simopts.n_phi = 100;                                            % Number of Discrete z'-Angle Elements during Far-Ground Viewfactor Calculation
simopts.n_sig = 100;                                            % Number of Discrete sigma-Angle Elements during Far-Ground Viewfactor Calculation
simopts.n_d = 50;                                               % Number of Discrete d Elements during Near-Ground Viewfactor Calculation (The number is automatically adjusted down for far-away regions)
simopts.n_zeta = 50;                                            % Number of Discrete zeta Elements during Near-Ground Viewfactor Calculation
simopts.hemispherePrecision = 'high';                           % Precision of Hemisphere Discretization (Presets: 'low','medium','high','ultra')
simopts.maxRowsConsidered = 20;                                 % Maximum Number of Rows Considered for Near-Ground Reflection


%% Irradiation Specification
% An arbitrary number N of irradiation situations can be specified
irradiation.DNI = linspace(550,600,5);                         % (1xN) Direct Normal Irradiation [W/m^2]
irradiation.GHI = linspace(200,400,5);                         % (1xN) Global Horizontal Irradiation [W/m^2]
irradiation.sunposition.azimuth_deg = linspace(-40,-20,5);     % (1xN) Sun Azimuth [deg] (0° = South, 90° = West)
irradiation.sunposition.elevation_deg = linspace(11,16,5);     % (1xN) Sun Elevation [deg] (0° = Horizontal)
irradiation.omega = linspace(0.79, 0.79,5);                    % (1xN) Near-Ground Surface Broadband Albedo
irradiation.omega_fg = linspace(0.3, 0.3, 5);                  % (1xN) Far-Ground Surface Broadband Albedo

%% Code Execution

results = runModel(configuration, irradiation, simopts);

% results is an (1xN) Cell Array of Structs that each contain the various
% fractions of irradiation incident on the panel front- and backside [W/m^2] , both as panel average (.avg_irrad_front and .avg_irrad_back) as well as the distribution on the sides:
%   .irradFront and .irradBack [W/m^2] are the sums of all contributions
%   .irrad_fract_... [W/m^2] are the contributions from direct irradiation, near-ground and far-ground reflections.
% .runInfo contains a summary of the input values for traceability.