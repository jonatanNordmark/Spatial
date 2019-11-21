function [neuralDataTable] = createNeuralDataTable_thesisUpgrade2019(channelSpikeStruct, Fs, behavMeta, behaviorM)

% This is so much better than previously!, JN 2019-11

% FUNCTION; createNeuralDataTable_thesisUpgrade2019, JN

neuralDataTable = [];


% ========================================================================

for tt = 1:size(behavMeta.trialStopTime,2) % For each trial
    clear temp_binEdges temp_neuralDataTable spikeTimings trialStop
    
    idxTrial = find(channelSpikeStruct.trialid == tt); % Find associated spikes
    spikeTimings = round(transpose(channelSpikeStruct.spikebin(idxTrial)/Fs).*1e3); % Find their timings
    
    trialStop = behavMeta.trialStopTime(tt);
    spikeTimings = spikeTimings(spikeTimings <= trialStop);
    temp_binEdges = behavMeta.trialBinEdges{tt};
    temp_neuralDataTable = histcounts(spikeTimings, temp_binEdges);
    
    neuralDataTable = [neuralDataTable temp_neuralDataTable];
   
   
end
