function [candidate_mat] = max_n_per_col(mat, n)
%picks out the n biggest values in each column of the mat
%   Detailed explanation goes here
candidate_mat = zeros(size(mat));
for i = 1:n
    [max_row, col_idx_row] = max(mat);
    for row_idx = 1:length(col_idx_row)
        col_idx = col_idx_row(row_idx);
        candidate_mat(col_idx, row_idx) = max_row(row_idx);
        mat(col_idx, row_idx) = 0;
    end
end

end

