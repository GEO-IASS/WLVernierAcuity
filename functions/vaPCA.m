function [imageBasisA,imageBasisC] = vaPCA(varargin)
% Make the principal component images for the absorptions and photocurrent
%
%  We used to do this separately for absorptions and current, but no
%  longer. Now, it is done for both, here.
%
% Steps:
%   Create a set of stimuli  with different offsets.
%   Calculate the responses over time
%   Combine the absorptions and currents into their large matrices
%   Compute the PCA across all the stimuli
%   Save two files with the parameters and the image bases.
%
% BW, ISETBIO Team, Copyright 2016

%%
p = inputParser;

p.KeepUnmatched = true;

p.addParameter('tStep',5,@isscalar);
p.addParameter('barWidth',3,@isscalar);
p.addParameter('tsamples',[],@isvector);
p.addParameter('timesd',20*1e-3,@isscalar);
p.addParameter('nBasis',20,@isscalar);

p.parse(varargin{:});

% Figure out a sensible way to set this.
nTrials = 20;

% tStep = p.Results.tStep;

nBasis = p.Results.nBasis;

% timesd   = p.Results.timesd;
% barWidth = p.Results.barWidth;
if isempty(p.Results.tsamples), tsamples = (-60:tStep:70)*1e-3;
else                            tsamples = p.Results.tsamples;
end

% Saved in the output files
basisParameters = varargin{1}; %#ok<NASGU>

%% Create the matched vernier stimuli

cMosaic = coneMosaic;

% Set the mosaic size to 15 minutes (.25 deg) because that is the spatial
% pooling size found by Westheimer and McKee
cMosaic.setSizeToFOV(0.25);

% Not sure why these have to match, but there is a bug and they do.
cMosaic.integrationTime = tsamples(2) - tsamples(1);

cMosaic.os.noiseFlag = 'random';
cMosaic.noiseFlag    = 'random';

%%  Store up the absorptions and current across multiple trials

absorptions = [];
current = [];
for offset = 0:1:8      % A large range of pixel offsets
    
    stimParams = p.Results;
    stimParams.barOffset = offset;     % Pixels on the display
    [~,thisStim] = vaStimuli(stimParams);
    tSamples = thisStim.length;

    emPaths = cMosaic.emGenSequence(tSamples,'nTrials',nTrials);
    
    [thisAbsorptions,thisCurrent] = cMosaic.compute(thisStim, ...
        'emPaths',emPaths, ...
        'currentFlag',true);
    % cMosaic.current = squeeze(mean(alignedC,1));
    % cMosaic.window;
    
    absorptions = cat(1,absorptions,thisAbsorptions);
    current = cat(1,current,thisCurrent);
    % Plot for one of the trials
    %  tmp = squeeze(thisAbsorptions(10,:,:,:));
    %  ieMovie(tmp);
    %
    % Show we did the cat the right way
    %  tmp = squeeze(absorptions(50,:,:,:));
    %  ieMovie(tmp);

end

%% Check that the movies make sense

% vcNewGraphWin;
% for ii=1:10:size(absorptions,1)
%     tmp = squeeze(absorptions(ii,:,:,:));
%     ieMovie(tmp);
%     pause(0.5);
% end

%% Convert the shape of the absorptions so we can perform the svd

tAbsorptions = trial2Matrix(absorptions,cMosaic);

% We make bases for each type of stimulus and then concatenate them.
[~,~,V] = svd(tAbsorptions,'econ');
imageBasis = V(:,1:nBasis); %#ok<*NASGU>

% Save the result and the parameters used to create the result
% When we load in s_vaAbsorptions we decide whether or not to recompute
% based on the match of basisParameters
save('imageBasisAbsorptions','imageBasis','basisParameters')
imageBasisA = imageBasis;

%% Convert the shape of the absorptions so we can perform the svd

tCurrent = trial2Matrix(current,cMosaic);

% We make bases for each type of stimulus and then concatenate them.
[~,~,V] = svd(tCurrent,'econ');
imageBasis = V(:,1:nBasis);

% Save the result and the parameters used to create the result When we load
% in s_vaCurrent we decide whether or not to recompute based on the match
% of basisParameters
save('imageBasisCurrent','imageBasis','basisParameters')
imageBasisC = imageBasis;

%% Visualize
% mx = max(imageBasis(:));
% mn = min(imageBasis(:));
% 
% % Have a look at the resulting bases
% vcNewGraphWin; 
% colormap(gray(256))
% for ii=1:nBasis
%     imagesc(reshape(imageBasis(:,ii),cMosaic.rows,cMosaic.cols),[1.2*mn 1.2*mx]);
%     title(sprintf('Basis %d',ii));
%     pause(1);
% end

end
