% SCRIPT; createMyDataTable_thesisUpgrade, JN 2019-11-18

% ==== Params ====

%FILE SPEC'
file = 'brillat004a03_p_MSO.m';
saveStr = 'M_brillat004a03_p_MSO';

%FIXED SETTINGS
binSize = 10; % ms
numChan = 64;
threshold = '.sig-4.';
blockType = '*MSO*.mat';
my_spfile_directory = '/home/jonny/Code/EXPERIMENTS/ANALYSIS/Data_thesisUpgrade2019/SP_brillat004a03_p_MSO';
my_file_directory = '/home/jonny/Code/EXPERIMENTS/ANALYSIS/Data_thesisUpgrade2019/';
Fs = 31250;

%% BEHAVIOR %%

% ==== Load Data ====
behav_file = strcat(my_file_directory,file);
run(behav_file)


% ==== Initialize ====

%OUTPUTS
behaviorM = [];
spikesM = [];

behavMeta = {};
spikesInBlock = [];

% ==== Process behavioral data ====
cd /home/jonny/Code/EXPERIMENTS/thesisUpgrade2019/Preprocessing/;
[behaviorM, behavMeta]= createBehavDataTable_thesisUpgrade2019(exptevents,exptparams,binSize); %Run the behavioural function...


%% SPIKES %%

% ==== Load data ====
spikeFolder = fullfile(my_spfile_directory, blockType);
theSpikeFiles = dir(spikeFolder);

% ==== Threshold data ====
idx_thresh = find(cellfun(@(x)not(isempty(strfind(x,threshold))),{theSpikeFiles(:).name})); %Files with the right thresholding
theSpikeFiles = theSpikeFiles(idx_thresh);

% ==== Sort data ====
channelIndex = zeros(1,numChan);

for cc = 1:numChan
    
    channel = strcat('elec',[num2str(cc),threshold,'mat']); % get spec'd channel
    idx_channel = find(cellfun(@(x)not(isempty(strfind(x,channel))),{theSpikeFiles(:).name}));
    
    if isempty(idx_channel) == 1 % In case the recording was made long ago and NOCOM was set as standard
        channel = strcat('elec',[num2str(cc),threshold,'NOCOM.mat']);
        idx_channel = find(cellfun(@(x)not(isempty(strfind(x,channel))),{theSpikeFiles(:).name}));
    end
    
   channelIndex(cc) = idx_channel;
    
end

theSpikeFiles = theSpikeFiles(channelIndex);

% ==== For each spike channel ====
for cc = 1:length(theSpikeFiles)
    
    % ==== Load into workspace ====
    cd '/home/jonny/Code/EXPERIMENTS/ANALYSIS/Data_thesisUpgrade2019/SP_brillat004a03_p_MSO'
    channelSpikeStruct = load(theSpikeFiles(cc).name);
    
    % ==== Process channel data ====
    cd /home/jonny/Code/EXPERIMENTS/thesisUpgrade2019/Preprocessing/;
    temp_spikes = createNeuralDataTable_thesisUpgrade2019(channelSpikeStruct, Fs, behavMeta, behaviorM);
    spikesM = [spikesM;temp_spikes];
    
        
end

clearvars -except behaviorM spikesM saveStr


% ==== Save data ====

saveDirectory = '/home/jonny/Code/EXPERIMENTS/thesisUpgrade2019/M';
pathS = fullfile(saveDirectory, saveStr);
save(pathS,'behaviorM','spikesM');

