function [ chunked_piano_roll, fullsize_roll ] = chunk_n_average( piano_roll, roll_fs, onset_time)
%Facilitate piano_roll clean up toward MIDI.
%   INPUT:
%   piano_roll: 
%       N*T matrix, where N is usually 88 or pitches, and T is time.
%   roll_fs:
%       double that gives fs of the piano roll (Hz);
%   onset_time:
%       a 1*K vector, listing onset times in seconds for all K detected
%       onsets.
%   OUTPUT:
%   chunked_piano_roll:
%       N*K matrix, N is pitches, and K is number of onsets. One averaged
%       chunk per onset.
%   fullsize_roll:
%       N*T matrix. same info as chunked_piano_roll, just the same size as
%       the original piano_roll input.

num_onsets = length(onset_time);
chunked_piano_roll = zeros(size(piano_roll,1),num_onsets);
fullsize_chunked_roll = zeros(size(piano_roll));

chunk_end = floor(onset_time(1) .* roll_fs); % to initialize, so the for loop can do less work.
for idx = 1:num_onsets
    if idx == 1
        chunk_start = floor(onset_time(1) .* roll_fs) + 1;
    else
        chunk_start = chunk_end + 1; % start where the previous one ended
    end
    
    if idx == num_onsets
        chunk_end = size(piano_roll,2);
    else    
        chunk_end = floor(onset_time(idx+1) .* roll_fs); % ends on the next onset.
    end
    
    chunk_mean = mean(piano_roll(:,chunk_start:chunk_end),2);
    chunked_piano_roll(:,idx) = chunk_mean; 
    fullsize_roll(:,chunk_start:chunk_end) = repmat(chunk_mean,1,length(chunk_start:chunk_end));
end


end

