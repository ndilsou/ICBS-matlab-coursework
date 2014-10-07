function [ correlations, correl_tickers ] = correlation( series, window, tickers, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if window <= 0
    window = 5
end

temp = find(strcmp(varargin,'annualise') == 1);
if isempty(temp)
    annualise = 252;
else
    annualise = temp;
end

[row, col] = size(series);
%That's the smartest way to obtain the right number of columns...
nb_correl = factorial(col)/(factorial(2)*factorial(col-2))
correlations = zeros(row-window+1,nb_correl);
correl_tickers = cell(1,nb_correl);


k = 1;
for i = 1:col-1
    for j=i+1:col
        correlations(:,k) = compute_correl([series(:,i), series(:,j)]);
        correl_tickers{1,k} = strcat(tickers(i,:), ':', tickers(j,:)) ;
        k = k + 1;
    end
end


%% Helper function
    function correl_pair = compute_correl(pair)
        [row, ~] = size(pair);
        correl_pair = zeros(row-window+1,1);
        stddev = sqrt(annualise*volatility(pair, window));
        for  t=window:row
           correl_pair(t-window+1,1) = sum(pair(t-window+1:t,1).*pair(t-window+1:t,2))/window ;
           correl_pair(t-window+1,1) = annualise*correl_pair(t-window+1,1)/ ...
               (stddev(t-window+1,1).*stddev(t-window+1,2));            
        end
    end

end
