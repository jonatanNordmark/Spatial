% FUNCTION; createBehavDataTable_thesisUpgrade2019, JN


function [behavDataTable, metaData] = createBehavDataTable_thesisUpgrade2019(exptevents,exptparams,binSize)

behavDataTable = [];
trial_idx_row = 13;
cued_idx_row = 14;


% find how many trials in block
trialEvents = [exptevents.Trial];
nTrials = unique(trialEvents);
nTrials = numel(nTrials);

% ==== For each trial in this block ====

for tt = 1:nTrials
    
    % ==== Indices for events within this trial ====
    
    trialNumber = tt;
    idx_currentTrial = find([exptevents.Trial] == trialNumber); % Get indices for events within the specified trial
    StartTimes = ({exptevents(idx_currentTrial).StartTime}); % ... and associated onset times
    StopTimes = ({exptevents(idx_currentTrial).StopTime}); % ... and associated offset times
    
    
    % ==== Find trial indices ====
    
    idx_stop = find(cellfun(@(x)not(isempty(strfind(x,'LICK'))),{exptevents(idx_currentTrial).Note}));
    
    if isempty(idx_stop) == 1 % In case of Miss OR Correct Rejection
        idx_stop = find(cellfun(@(x)not(isempty(strfind(x,'TRIALSTOP'))),{exptevents(idx_currentTrial).Note}));
    end
    
    trialStop = cell2mat(StartTimes(idx_stop)).*1e3; % Convert to ms
    trialStop = trialStop(1); % In case of glitch in baphy (which has happened)...
    numBinsInTrial = numel(0:binSize:trialStop)-1;
    
    temp_behavDataTable(trial_idx_row,(1:numBinsInTrial)) = tt; % Assign to table
    
    
    % ==== Create bin-edges ====
    
    binEdges = 0:binSize:trialStop; % Useful for later...
    
    % ==== Create struct with meta data ====
    metaData.trialStopTime(tt) = trialStop;
    metaData.trialBinEdges(tt) = {binEdges};
    
    
    % ==== LOUDSPEAKER ====
    
    for loudspeaker = 1:12
        
        string_template = strcat(['Stim , 01-White  ClickChannel ',num2str(loudspeaker),' , Reference']);
        
        
        idx_rfChan = find(cellfun(@(x)not(isempty(strfind(x,string_template))),{exptevents(idx_currentTrial).Note}));
        
        rfChan_ON = cell2mat(StartTimes(idx_rfChan)).*1e3; % in onset times, find the events on channel for references
        rfChan_OFF = cell2mat(StopTimes(idx_rfChan)).*1e3; % Yes!! - because both onset/offset have the same row index
        
        vectorRfChan = [];
        
        
        for jj = 1:numel(rfChan_ON)
            temp_vectorRfChan = rfChan_ON(jj):(rfChan_OFF(jj)-1); % Populate a vector with stimuli timings
            vectorRfChan = [vectorRfChan temp_vectorRfChan];
        end
        
        vectorRfChan = vectorRfChan(vectorRfChan <= trialStop); % Only include stimuli which were played
        rfChan = histcounts(vectorRfChan,binEdges); % Create histogram
        rfChan(rfChan > 1) = 1; % Binarize
        
        for kk = 1:numBinsInTrial
            temp_behavDataTable(loudspeaker,kk) = rfChan(kk);
        end
        
    end
    
    
    % ==== Find cued channel 'CSS' ====
    clear loudspeaker
    for loudspeaker = 1:12
        string_template_cued = strcat(['Channel ',num2str(loudspeaker),' CSS']);
        idx_cued_chan = find(cellfun(@(x)not(isempty(strfind(x,string_template_cued))),{exptevents(idx_currentTrial).Note}));
        if ~isempty(idx_cued_chan)
            break
        end
    end
        
        temp_behavDataTable(cued_idx_row,(1:numBinsInTrial)) = loudspeaker;
        
        % ==== ASSIGN ALL OUTPUTS TO TABLE ====
        behavDataTable = [behavDataTable temp_behavDataTable];
        
        
        % ==== Clear temporary variables ====
        clear temp_behavDataTable
        
        
    
 end%END LOOP OVER TRIALS
end
    
    
