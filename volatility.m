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
    variances(i-window+1,:) = sum(series(i-window+1:i,:).^2)/window ;
    %Solution 2
    % variances(i-window+1,:) = var(series(i-window+1:i,:)) ;
end

end

