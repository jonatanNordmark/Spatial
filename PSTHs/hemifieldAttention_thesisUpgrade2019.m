%hemifieldAttention_thesisUpgrade2019, JN 2019-11

clear
close all
clc

% COMPARE RESPONSES LEFT/RIGHT WHEN ATTENTION WAS DIRECTED WITHIN/WITHOUT

% ==== Load data ====
cd /home/jonny/Code/EXPERIMENTS/thesisUpgrade2019/M
load('M_brillat004a03_p_MSO.mat')

% ==== Select Data ====
spike_matrix = spikesM;
behav_matrix = behaviorM;

% cued_two= find((behav_matrix(14,:)==2) & ((behav_matrix(1,:)==1) | (behav_matrix(3,:)==1)));
% cued_eleven = find((behav_matrix(14,:)==11) & ((behav_matrix(1,:)==1) | (behav_matrix(3,:)==1)));

cued_two= find((behav_matrix(14,:)==2) & ((behav_matrix(10,:)==1) | (behav_matrix(12,:)==1)));
cued_eleven = find((behav_matrix(14,:)==11) & ((behav_matrix(10,:)==1) | (behav_matrix(12,:)==1)));

A = mean(mean(spike_matrix(:,cued_two)));
B = mean(mean(spike_matrix(:,cued_eleven)));

A/B
blblb


    




