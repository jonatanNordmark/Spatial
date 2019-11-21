%createSpatialTuningPerLocation_denmarkBrain2019, JN 2019-05

clear
close all
clc

% ==== Set params ====

% GETSNIPPETS
get_snippets_bins = (5+5+5); get_snippets_center = 6;

% ==== Load data ====
cd /home/jonny/Code/EXPERIMENTS/thesisUpgrade2019/M
load('M_brillat004a03_p_MSO.mat')

% ==== For each channel ====
for spike_channel = 1:size(spikesM,1) % Loop over channels
    
    f(spike_channel) = figure; hold on % One figure per channel
    set(f(spike_channel), 'color','w');
    
    spike_matrix = spikesM;
    behav_matrix = behaviorM;
    
    
    % ==== FOR EACH CLICK LOCATION ====
    % Here, we clean the data for getsnippets
    
    for clickLocation = 1:12 % For each loudspeaker location, i.e. 12
        
        %GET THE INDEX OF THE CLICK ONSET
        for clickOnset = 1:size(behav_matrix,2)
            
            if behav_matrix(clickLocation,clickOnset) == 1
                
                %REPLACE CLICK DURATION WITH '0', KEEP ONLY ONSETS
                behav_matrix(clickLocation,[clickOnset:clickOnset+4]) = [1 0 0 0 0];
            end
        end
    end
       
    
    % ==== GETSNIPPETS, spike matrix centered around click onset ====
    
    % for each location
    for loudspeaker = 1:12
    
    location = GetSnippets(spike_matrix(spike_channel,:),behav_matrix(loudspeaker,:),get_snippets_center, get_snippets_bins);
    sem_location = std(location,0,1,'omitnan')./(sqrt(size(location,1)));
    mean_location = mean(location,1,'omitnan');
    
    
    % ==== Plot ====
    clim = [0 1];
    myXaxis = 1:get_snippets_bins;
    
    myColor= {'color',([0 255 0])./255, 'linewidth',3}; %GREEN
    
    subplot(2,12,loudspeaker); hold on
    h1 = shadedErrorBar(myXaxis,mean_location,2.*sem_location,myColor,1);
    xlim([1 get_snippets_bins])
    ylim([0 0.6])
    line([0 get_snippets_bins],[0 0], 'color' ,'k')
    line([get_snippets_center get_snippets_center],[min(ylim) max(ylim)],'color','r')
    line([get_snippets_center+4 get_snippets_center+4],[min(ylim) max(ylim)],'color','r')
    xlabel('1','FontSize',8)
    xticks([1:get_snippets_bins])
    set(gca,'Xticklabel',[])
    
    
    subplot(2,12,12+loudspeaker)
    imagesc(location,clim)
    set(gca,'Xticklabel',[])
    line([get_snippets_center get_snippets_center],[min(ylim) max(ylim)],'color','r')
    line([get_snippets_center+4 get_snippets_center+4],[min(ylim) max(ylim)],'color','r')
    shg
    
    
    end %End loop over each location
    
    
    
    
    
end %Loop over channel

