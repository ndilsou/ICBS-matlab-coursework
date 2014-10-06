function [ ret, cum_ret, dCarry , dIR, varargout ] = carry_trade( dates_index, dataset,mode, begin_date, end_date )
%CARRY_TRADE perform a carry trade run on the date provided.
%   Detailed explanation goes here

%% 1) We define the date index for any 2 years chosen by the user.
years_index = year(dates_index);
%TODO handle the default case where the user doesn't want to specify a
%begin and/or end date.
flag = and(years_index >= begin_date,years_index < end_date) ;

dataset = dataset(flag,:);
%%
rx = Extract_excess_returns(dataset);

if mode == false % Non rebalanced portfolio
    %The return is the differential of the excess returns of the 2 first
    %variables (assumption). Note that we assume the investor is Long in
    %the first asset provided, short in the second.
    ret = rx(:,1) - rx(:,2);
    cum_ret = mycumreturns(ret);
    
    %decomposition of the returns
    [dSpot1, IRP1 ] = returns_decomposition(dataset(:,1:2));
    [dSpot2, IRP2 ] = returns_decomposition(dataset(:,3:4));
    
    dCarry = dSpot1 - dSpot2; %depreciation Carry
    dIR = IRP1(2:end,:) - IRP2(2:end,:); %Interest Rate differential
    
else %Rebalanced portfolio
    [row, col] = size(dataset);
    mask = 1:2:col;
    
    %we will set a zeros matrices with as much row as trading period and as
    %much column as currencies. We will then loop over the period. At each
    %period, if we must go short we replace the 0 by -1. for the two
    %currencies in which we will go long we replace the 0 by a 0.5. We then
    %use this 'flag' to compute the return for each period of our ptf.
    positions = zeros(row-1, col/2); %we drop 1 period anyway.
    %Main loop, for each period we take our trading decision
    for i=1:(row-1)
        [ ~ , sort_index] = sort(dataset(i,mask));
        positions(i,sort_index(end)) = 0.5;
        positions(i, sort_index(end-1)) = 0.5;
        positions(i,sort_index(1)) = -1;
    end
    %Know that we have the decision rule we extract the meaningfull
    %returns.
    ret = sum(rx.*positions,2);
    cum_ret = mycumreturns(ret);
    [dSpot, IRP ] = returns_decomposition(dataset);
    dCarry = sum(dSpot.*positions,2);
    dIR = sum(IRP(2:end,:).*positions,2);
    varargout{1} = positions;
end


%% Helper function
    function cum_returns = mycumreturns(returns)
       total_returns = 1 + returns;
       cum_returns = 100*cumprod(total_returns);
    end
end

