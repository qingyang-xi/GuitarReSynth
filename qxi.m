%% Compute using transcription
[pianoRoll3] = transcription('AHa_TakeOnMe_STEM_04_test.wav',50,3,1.0,1.0,1.0);
[pianoRoll4] = transcription('AlexanderRoss_GoodbyeBolero_STEM_01_excerpt.wav',50,3,1.0,1.0,1.0);
%% Simple Thresholding... Doesn't Work...
% mat_mean = mean(mean(pianoRoll3));
% alpha = 5;
% tresholded = max(pianoRoll3 - mat_mean*alpha,0);
% figure(1);imagesc(flipud(tresholded));
 figure(1);imagesc(flipud(pianoRoll3));
% 
%% Horizontal averaging according to tempogram?

%% Pick the best 6 out of each col.
n = 6;
roll_copy = pianoRoll3;
candidate_mat = zeros(size(roll_copy));
for i = 1:n
    [max_row, col_idx_row] = max(roll_copy);
    for row_idx = 1:length(col_idx_row)
        col_idx = col_idx_row(row_idx);
        candidate_mat(col_idx, row_idx) = max_row(row_idx);
        roll_copy(col_idx, row_idx) = 0;
    end
end
%figure(2);imagesc(flipud(pianoRoll4));
figure(4); imagesc(flipud(candidate_mat));

%% Threshold