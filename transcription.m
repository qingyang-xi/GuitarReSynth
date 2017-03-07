function [pianoRoll] = transcription(filename,iter,S,sz,su,sh)
% e.g. [pianoRoll] = transcription('bcfho_mix.wav',50,3,1.0,1.0,1.0);
%
% An efficient temporally-constrained probabilistic model for multiple-instrument music transcription
%
% Inputs:
%  filename filename for .wav file
%  iter     number of iterations (e.g. 30)
%  S        number of sources (e.g. 3)
%  sz       sparsity parameter for pitch activation (e.g. 1.0-1.3)
%  su       sparsity parameter for source contribution (e.g. 1.0-1.3)
%  sh       sparsity parameter for pitch shifting (e.g. 1.0-1.3)
%
% Outputs:
%  pianoRoll raw piano-roll output (dims: P x T, P: pitch index, T: 20ms step)
%
% Emmanouil Benetos 2015


% Load note templates and initialize
load('shiftedW');
pitchActivity = [20 20 20; 70 70 70]';
W = permute(shiftedW,[4 5 2 1 3]);
W = W(:,1:S,:,:,:);


% Compute VQT and perform simple noise reduction
[intCQT] = computeVQT(filename);
X = intCQT(:,round(1:5.2883:size(intCQT,2)))';
noiseLevel1 = medfilt1(X',40);
noiseLevel2 = medfilt1(min(X',noiseLevel1),40);
X = max(X-noiseLevel2',0);
Y = X(1:2:size(X,1),:);
clear('intCQT','X','noiseLevel1','noiseLevel2');


% Perform efficient 5-D HMM-constrained PLCA
[w,h,z,u,xa] = plca_5d_fast_hmm( Y', 88, S, 5, 3, iter, sh, sz, su, W, [], [], [], [], pitchActivity);


% Raw piano-roll output
pianoRoll = z;
