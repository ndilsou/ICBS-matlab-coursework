function [ dSpot, IRP ] = returns_decomposition( returns )
%returns_decomposition 
% we extract the spot variation for each currency
% OUTPUT : 
%- dSpot : size(row-1, col)
%- IRP : size(row-1, col)
[row, col] = size(returns);

dSpot = zeros(row-1,col/2); %Spot variation for each pair
IRP = zeros(row,col/2); %Interest rate parity for each pair
j = 1;
for i=1:2:col %We dont care about the fwd component here
    dSpot(:,j) = diff(returns(:,i),1);
    IRP(:,j) = returns(:,i+1) - returns(:,i);
    j = j+1;
end


end

