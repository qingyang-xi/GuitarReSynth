function [] = create_novelty_plots(filepath, win_size, hop_size, ...
    w_c, medfilt_len, offset) % ground truth filepath)
% Plot waveform, novelty functions, preprocessing steps, and onsets.
%
% Parameters
% ----------
% filepath : string
% path to a .wav file
% win size : int
% window size for novelty function (in samples)
% hop size : int
% hop size for novelty function (in samples)
% w c : float
% peak picking cutoff frequency for Butterworth filter (Hz)
% medfilt len : int
% peak picking length of the median filter used in adaptive threshold. (samples)
% offset : float
% peak picking offset in adaptive threshold.
%
% Returns
% -------
% None

%% Get audio signal and n_t
[x_t, fs, t] = import_audio(filepath);
[n_t_sf, t_sf, fs_sf] = compute_novelty_sf(x_t, t, fs, win_size, hop_size);
[n_t_le, t_le, fs_le] = compute_novelty_le(x_t, t, fs, win_size, hop_size);
[onset_a_le, onset_t_le, n_t_smoothed_le, thresh_le] = onsets_from_novelty(n_t_le, t_le, fs_le, w_c, medfilt_len, offset);
[onset_a_sf, onset_t_sf, n_t_smoothed_sf, thresh_sf] = onsets_from_novelty(n_t_sf, t_sf, fs_sf, w_c, medfilt_len, offset);
%% plot
figure()
suptitle(filepath)
% first the waveform
subplot(311)
plot(t,x_t);
title('Time domain Waveform')
xlabel('time (sec)')
ylabel('amplitude')
xlim([0, t(end)])
% log energy derivative novelty
subplot(312)
plot(t_le, n_t_le, 'r-');
hold on;
plot(t_le, n_t_smoothed_le, 'k-');
plot(t_le, thresh_le, 'b:');
plot(onset_t_le, onset_a_le, 'ko');
hold off;
title('log energy derivative novelty')
xlabel('time (sec)')
ylabel('normalized amplitude')
xlim([0, t(end)])
% Half rectified spectral flux
subplot(313)
plot(t_sf, n_t_sf, 'r-');
hold on;
plot(t_sf, n_t_smoothed_sf, 'k-');
plot(t_sf, thresh_sf, 'b:');
plot(onset_t_sf, onset_a_sf, 'ko');
hold off;
title('Rectified Spectral Flux novelty')
xlabel('time (sec)')
ylabel('normalized amplitude')
xlim([0, t(end)])
end


