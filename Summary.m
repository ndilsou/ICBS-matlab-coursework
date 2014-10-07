function [] = summary(dates_index, dataset, tickers, varargin)
% SUMMARY Compute basic statistics and plot the series
%INPUT :
%- dates_index (datestring or datetime) : array of the dates that will be
%used as a X axis
%- dataset (float) : array of the variable to plot
%- tickers (string) : array of the name for each variable.
% OUTPUT :
% void

%TOFIX : more flexibility in the data management. Add a variable for the
%annualisation parameter. Check the lenght of the series for the plot.

    [rows, nb_series] = size(dataset);
    
    temp = find(strcmp(varargin,'annualise') == 1);
    if isempty(temp)
        annualise = 252;
    else
        annualise = varargin{temp+1};
    end
    
    if ischar(dates_index)
        dates_index = datenum(dates_index);
    end
    
    figure
    for i=1:nb_series
        fprintf('Series : %s \n\n',  tickers(i,:));
        
        %statistics
                
        annualized_mean = annualise*mean(dataset(:,i));
        fprintf('Annualized Mean : %3f\n',annualized_mean); 
        annualized_std = sqrt(annualise)*std(dataset(:,i));
        fprintf('Annualized Standard Deviation : %3f\n',annualized_std); 
        data_skewness = skewness(dataset(:,i));
        fprintf('Skewness : %3f\n',data_skewness); 
        data_kurtosis = kurtosis(dataset(:,i));
        fprintf('Kurtosis : %3f\n\n',data_kurtosis); 
         %
        fprintf('Max : %3f\tMin : %3f\n\n',max(dataset(:,i)),min(dataset(:,i)));         
        quartile = quantile(dataset(:,i),[0.25, 0.5, 0.75]);
        fprintf('Quartile 25%% : %3f\nQuartile 50%% : %3f\nQuartile 75%% : %3f\n\n', ...
            quartile(1),quartile(2),quartile(3)); 
        
        %Plotting
        if nb_series > 1
            subplot(2,nb_series/2,i);
        end

        plot(dates_index,dataset(:,i)*100);
        datetick('x','keeplimits');
        ylabel('(%)');
        xlabel('years');
        title(['Evolution of the serie for ', tickers(i,:)]);
    end
    hold off
end