function [avg_accuracy] = mermaid_plot_tester(prediction_time, regression_size, regression_degree)
  % [avg_accuracy] = MERMAID_PLOT_TESTER(prediction_time, regression_size, regression_degree)
  %
  % This function predicts or tests predictions for future mermaid
  % locations
  %
  % Input: prediction_time (the number of time in seconds in the future for
  %                         prediction, default is 604800 (1 week)
  %        regression_size (number of points to use for regression)
  %        regression_degree (degree for polyfit
  %
  % Output: avg_accuracy (distance in km from actual final position to predicted
  %         final position)
  %
  % With default parameters: # predictions within 10km = 50^(1/# weeks in advance) 
  %
  % Last modified by Jonah Rubin, 6/28/19
  
  defval('prediction_time', 604800);
  defval('regression_size', 2);
  defval('regression_degree', 1);

  dists = [];
  names = {};
  lat_ships = [-17.3,-12.0,-10.0,-8.0,-6.0,-5.0,-6.0,-8.0,-13.0,-17.0,-22.0,-27.0,-28.0,-29.0,-30.0,-31.0,-30.0,-29.0,-28.0,-27.0,-26.0,-25.65,-25.63,-25.0,-24.0,-22.2];
  lon_ships = [-149.3,-151.0,-150.0,-149.0,-148.0,-146.0,-144.0,-139.0,-135.0,-136.0,-141.0,-149.0,-151.0,-154.0,-157.0,-160.0,-164.0,-166.0,-168.0,-170.0,-172.0,-174.9,-177.6,-179.0,-180.0,-193.7];
  lat_predicts = [];
  lon_predicts = []; 
  numfloats = 25;
  threshold = 10;
  for i=1:25
  %for i=[16,17,23,24]

    if i < 10
	  name = ['P00' num2str(i)];
    else
      name = ['P0' num2str(i)];
    end
    
    try
        [lat_predict, lon_predict, lat_actual, lon_actual] = mermaid_plot(name, prediction_time, regression_size, regression_degree);
         accuracy = haversine(lat_predict, lon_predict, lat_actual, lon_actual);
         if isnan(accuracy) | (name == 'P003')
         else
             dists = [dists accuracy/1000];
	         names{end+1} = num2str(i);
             lat_predicts = [lat_predicts lat_predict];
             lon_predicts = [lon_predicts lon_predict];
%              n = name
%              la = lat_predict
%              lo = lon_predict
         end
    catch
        fprintf('Failed on %s\n',num2str(i))
    end
    
  end
  
  figure(3)
  hold on;
  dist_mean = mean(dists);
  dist_var = var(dists);

  accuracy_hist = cdfplot(dists);
  threshold_line = plot([threshold threshold], ylim);

  title('Accuracy CDF');
  xlabel('Distance (km)');
  ylabel('Fraction of occurences');
  leg(1) = plot(NaN,NaN,'-r', 'markersize', 15);
  legend(leg, strcat(num2str(threshold), ' km threshold'));
  
  figure(4)
  grid on;
  hold on;
  
  prediction_date = datetime('now', 'InputFormat', 'HH:mm:ss' );
  prediction_date.Format = 'eeee, MMMM d, yyyy HH:mm:ss';
  prediction_date = datestr(prediction_date + seconds(prediction_time));
  
  title(['Predicted Surfacings and Ship Trajectory for ' prediction_date]);
  xlabel('longitude');
  ylabel('latitude');
  plot(lon_predicts, lat_predicts, '*r', 'markersize', 8);
  text(lon_predicts, lat_predicts, names);
  plot(lon_ships, lat_ships, '-k', 'marker', 's','markersize', 8);
  leg4(1) = plot(NaN,NaN,'-sk', 'markersize', 8);
  leg4(2) = plot(NaN,NaN,'*r', 'markersize', 8);
  legend(leg4, 'Float Deployments', 'Float Predictions');



