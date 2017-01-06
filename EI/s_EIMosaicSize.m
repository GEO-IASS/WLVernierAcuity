%% Impact of cone mosaic size
%
% This complements the bar length analysis.  It should tell a similar story.
%

% Show the dependence on spatial size of the cone mosaic for the computational
% observer.
nTrials = 300;
nBasis  = 40;

% Integration time 
tStep   = 10;  % Adequate for absorptions (ms)

% Cone mosaic field of view in degrees
coneMosaicFOV = 0.25;

% Original scene
sceneFOV = 0.35;

% Spatial scale to control visual angle of each display pixel The rule is 6/sc
% arc sec for a 0.35 deg scene. If you change the scene to 0.5 deg then 0.5/0.35
sc = 1.5*(sceneFOV/0.35);  % 4 arc sec

s_EIParameters;

%% Summarize

% Each pixel size is 6 arc sec per pixel when sc =  1.  Finer resolution when sc
% is higher.
secPerPixel = (6 / sc);
minPerPixel = (6 / sc) / 60;
degPerPixel = minPerPixel/60;
fprintf('Bar length is %.1f deg, %.1f min\n',...
    (params.vernier.barLength*degPerPixel),...
    (params.vernier.barLength*minPerPixel));

%%
fprintf('Bar offset per pixel is %.1f sec\n',secPerPixel);
barOffset = [0  1 2 3  4 ];

cmFOV = [.1 .15 .25 .35];    % Degress of visual angle
PC = zeros(length(barOffset),length(cmFOV));

%% Compute classification accuracy
tic;
parfor pp = 1:length(cmFOV)
    thisParam = params;
    thisParam.cmFOV = cmFOV(pp);
    P = vaAbsorptions(barOffset, thisParam);
    PC(:, pp) = P(:);
end
toc
% mesh(PC)

%% Make summary graph
% Legend
lStrings = cell(1,length(cmFOV));
for pp=1:length(cmFOV)
    lStrings{pp} = sprintf('%.2f deg',cmFOV(pp));
end

h = vcNewGraphWin;
plot(secPerPixel*barOffset,PC);
xlabel('Offset arc sec'); ylabel('Percent correct')
grid on; l = legend(lStrings);
set(l,'FontSize',12)

%%
str = datestr(now,30);
fname = fullfile(wlvRootPath,'EI','figures',['mosaicSize-',str,'.mat']);
save(fname, 'PC','params', 'barOffset', 'cmFOV','scenes');

%%
% Find the files with EI/figures/mosaicSize-XXXX
% load(fname)
