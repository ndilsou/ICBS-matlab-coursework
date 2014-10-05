%% General Comments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The data are assumed to be in the same folder as the main file
%% Data  Preprocessing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We will assume that the data are relatively clean. i.e the data extracted
% from the excel files can be readily used.
clear all
close all
tickers = ['USD/AUD'; 'USD/JPY'; 'USD/NZD'; 'USD/CHF'];
%the dates are structured as numeric variable. The only text data in the
%file must be the header.
[data, header ] = xlsread('FX-data', 'data'); 
[row, col] = size(data);

years = unique(data(:,1));
disp('First and last year of the dataset :');
disp([min(years), max(years)]);
% We see that the dataset spans from 1984 to 2011
%We build the index of dates. We need to add three zeros columns for the
%function to run properly
dates_index = datestr([data(:,1:3) zeros(row,3)]);
%We want to retrieve data at monthly frequency. This means that the first
%day of each month must be identified. The pattern is that if the last day
%was bigger than the current day, then we changed month.

monthly_flag = zeros(row,1);
for i=2:row
   if data(i,3) < data(i-1,3)
       monthly_flag(i,1) = 1;
   end
end
%Matlab needs logical values for indexing
monthly_flag = logical(monthly_flag);

%We take the log of the data. 
log_data =  log(data(:,4:end));
monthly_log_data = log_data(monthly_flag,:);


%% Exchange Rate Changes and Excess Returns using forward contracts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

monthly_dates_index = dates_index(monthly_flag,:);
monthly_dates_index = monthly_dates_index(2:end,:);

rx = Extract_excess_returns(monthly_log_data);
Summary(monthly_dates_index,rx,tickers);

%% The Carry Trade.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%returns = monthly_log_data;

% we extract the spot variation for each currency
[dSpot, IRP] = returns_decomposition( monthly_log_data );



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
















