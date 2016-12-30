%% s_EIScratch
% Sets up parameters and runs s_vaAbsorptions

nTrials = 500;
% Integration time and time step of the movie
tStep   = 30;  % Adequate for absorptions
% tStep   = 5;   % Useful for current

% Set the number of image bases
nBasis = 30;

% Cone mosaic field of view in degrees
coneMosaicFOV = 0.25;

% s
% Scene field of view in degrees
sceneFOV      = 0.35;
% Sets the number of steps in the curve
barOffset = [0 2 4 6];

% Set basic parameters for the vernier stimulus
clear params;
v = vernierP;
v.gap = 0;
v.bgColor = 0.1;

% For a scene fov of 0.35 and a size of 210,210, 1 pixel offset is 6 sec of
% arc.  Scaling them together preserves this 6 arc sec value. 
v.sceneSz = [210 210];
v.barWidth  = 10;
v.barLength = 200;
% Attach the vernier parameters
params.vernier = v;

% These are oisequence and other parameters
params.tsamples  = (-200:tStep:200)*1e-3;   % In second M/W was 200 ms
params.timesd  = 100*1e-3;                  % In seconds                 
params.nTrials = nTrials;
params.tStep   = tStep;
params.nBasis  = nBasis;
params.fov     = coneMosaicFOV;             % Field of view of cone mosaic in deg
params.distance = 0.3;
params.em      = emCreate;
params.em.emFlag = [1 1 1]';

% vaPCA(params);

% We need to visualize the imageBasis.  Here would be a good spot.
s_vaAbsorptions
% s_vaAbsorptionsHex

% s_vaCurrent

%%
params = 

    barOffset: 6
     barWidth: 3
     tsamples: [1x22 double]
       timesd: 0.0400
      nTrials: 400
        tStep: 8

X = [0 2 4 6 ]
P = [51.25 88.12 97.50 100.00 ]
