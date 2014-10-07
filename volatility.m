function [ variances ] = volatility( series, window )
%VOLATILITY Compute the moving window volatility
%   
if window <= 0
    window = 5;
end

[row, col] = size(series);
variances = zeros(row-window,col);

for i=window:row
    %Solution 1
    variances(i-window+1,:) = diag(series(i-window+1:i,:)'*series(i-window+1:i,:))'/window ;
    %Solution 2
    % variances(i-window+1,:) = var(series(i-window+1:i,:)) ;
end

end

