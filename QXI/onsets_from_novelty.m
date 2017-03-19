function [onset_a, onset_t, n_t_smoothed, thresh] = ...
    onsets_from_novelty(n_t, timet, fs, w_c, medfilt_len, offset)
% Peak pick a novelty function.
%
% Parameters
% ----------
% n_t : 1 x L array
% novelty function
% t : 1 x L array
% time points of n_t in_seconds
% fs : float
% sample rate of n_t (samples per second)
% w_c : float
% cutoff frequency for Butterworth filter (Hz)
% medfilt_len : int
% Length of the median filter used in adaptive threshold. (samples)
% offset : float
% Offset in adaptive threshold.
%
% Returns
% -------
% onset_a : 1 x P array
% onset amplitudes
% onset_t : 1 x P array
% time values of detected onsets (seconds)
% n_t_smoothed : 1 x L array
% novelty function after smoothing.
% thresh : 1 x L array
% adaptive threshold.

%% smoothing using butterworth filter and normalize
nyq = fs / 2;
[B,A] = butter(1, w_c/nyq);
n_t_smoothed = filtfilt(B,A,n_t);
n_t_smoothed = n_t_smoothed ./ (max(abs(n_t_smoothed))); % normalize
%% Adaptive Threshold
thresh = medfilt1(n_t_smoothed, medfilt_len) + offset;
%% onset detection
[all_pks,all_locs] = findpeaks(n_t_smoothed); % all the peaks
% compare all the potential peaks with threshold and record all the valid
% peaks.
max_num_of_peaks = length(all_pks);
onset_a = zeros(1,max_num_of_peaks);
onset_t = onset_a;
peak_count = 0;
for i = 1:max_num_of_peaks
    if all_pks(i) > thresh(all_locs(i)) % it is a valid peak!
        peak_count = peak_count + 1;
        onset_a(peak_count) = all_pks(i);
        onset_t(peak_count) = timet(all_locs(i));
    end
end

%% clean up the zeros at the end
onset_a = onset_a(1:peak_count);
onset_t = onset_t(1:peak_count);
end
    
    

