function [] = summary(dates_index, dataset, tickers)
% SUMMARY Compute basic statistics and plot the series
%INPUT :
%- dates_index (datestring or datetime) : array of the dates that will be
%used as a X axis
%- dataset (float) : array of the variable to plot
%- tickers (string) : array of the name for each variable.
% OUTPUT :
% void
%TOFIX : more flexibility in the data management.

    [rows, nb_series] = size(dataset);
    
    if ischar(dates_index)
        dates_index = datenum(dates_index);
    end
    
    figure
    hold on
    for i=1:nb_series
        fprintf('Series : %s \n\n',  tickers(i,:));
        
        %statistics
                
        annualized_mean = 12*mean(dataset(:,i));
        fprintf('Annualized Mean : %3f\n',annualized_mean); 
        annualized_std = sqrt(12)*std(dataset(:,i));
        fprintf('Annualized Standard Deviation : %3f\n',annualized_std); 
        data_skewness = skewness(dataset(:,i));
        fprintf('Skewness : %3f\n',data_skewness); 
        data_kurtosis = kurtosis(dataset(:,i));
        fprintf('Kurtosis : %3f\n\n',data_kurtosis); 
        
        
        %Plotting
        subplot(2,nb_series/2,i)
        plot(dates_index,dataset(:,i)*100);
        datetick('x','keeplimits');
        ylabel('(%)');
        xlabel('years');
        title(['Evolution of the excess return for ', tickers(i,:)]);
    end
    hold off
end