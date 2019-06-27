function [avg_accuracy] = mermaid_plot_tester()
  % [avg_accuracy] = MERMAID_PLOT_TESTER()
  %
  % This function tests the accuracy of the mermaid_plot function
  %
  % Input: none
  % Output: average distance in m from actual final position to predicted
  %         final position
  %
  % Last modified by Jonah Rubin, 6/20/19

  dists = [];
  names = [];
  threshold = 20;
  for i=1:25
    if i < 10
	  name = ['P00' num2str(i)];
    else
      name = ['P0' num2str(i)];
    end
    
    try
        [lat_predict, lon_predict, lat_actual, lon_actual] = mermaid_plot(name);
         accuracy = haversine(lat_predict, lon_predict, lat_actual, lon_actual)
         if isnan(accuracy)
         else
             dists = [dists accuracy/1000]
	         names = [names i]
         end
    catch
    end
    
  end
  
  figure(3)
  hold on;
  dist_mean = mean(dists);
  dist_var = var(dists);

  %accuracy_hist = histogram(dists, length(names)+5);
  accuracy_hist = cdfplot(dists);
  
  threshold_line = plot([threshold threshold], ylim);
  
  leg(1) = plot(NaN,NaN,'-r', 'markersize', 15);

  title('Accuracy CDF');
  xlabel('Distance (km)');
  ylabel('Fraction of occurences');
  legend(leg, strcat(num2str(threshold), ' km threshold'));


