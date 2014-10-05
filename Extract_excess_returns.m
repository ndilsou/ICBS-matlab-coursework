function [ RX ] = extract_excess_returns( returns )
%EXTRACT_EXCESS_RETURNS retrieve the excess returns given a set of spot/fwd
%returns
%   The function act as a wrapper for the exercice 1. The function loop
%   over the pairs of data and calculate the excess return RX based on
%   the formula : rx{t+1} = f{t} - s{t+1}

[row, col] = size(returns);
pairs = col/2; %The number of pairs of currencies. 
RX = zeros(row-1, pairs); 


%one 't' is lost as we take the differential between ft en s(t+1)

j = 1;
for i=1:2:col
    %We must shift the data and drop one value.
    excess_ret = returns(1:end-1,i+1) - returns(2:end,i);
    RX(:,j) = excess_ret;
    j = j+1;
end


end

