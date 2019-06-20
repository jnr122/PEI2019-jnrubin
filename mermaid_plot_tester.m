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
  
  dists = []
  
  for i=1:25
    if i < 10
        name = ['P00' num2str(i)];
    else
        name = ['P0' num2str(i)];
    end
    
    try
        [lat_predict, lon_predict, lat_actual, lon_actual] = mermaid_plot(name);
         accuracy = haversine(lat_predict, lon_predict, lat_actual, lon_actual);
         if isnan(accuracy)
         else
             dists = [dists accuracy]
         end
    catch
    end
    
  end
  
  avg_accuracy = mean(dists)