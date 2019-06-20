function [lat_predict, lon_predict] = latlon_tseries(lats, lons, times, size, t, degree)
  % [lat_predict, lon_predict] = LATLON_TSERIES(events)
  %
  % This function plots lat and lon arrays as separate time series
  % 
  %
  % Input: lats, lons, times (corresponding lat, lon, and time arrays)
  %        t (the number of seconds since last report to retrieve prediction)
  %        size (the number of datapoints to use for the regression)
  %        degree (degree of polynomial regression)
  %
  % Output: lat_predict, lon_predict (predicted lat lon at given time)
  %
  % Last modified by Jonah Rubin, 6/20/19
  
  figure(2)
  title('Lat Lon Timeseries');
  xlabel('time (seconds)'); 
  ylabel('displacement (degrees)');
  hold on;
  grid on;
  
  % (times - 1) allows testing on known data
  times = datenum(times(1:length(times-1)))* 24 * 3600;
  
  %lat_data = plot(times, lats, '+k', 'markersize', 3);
  %lon_data = plot(times, lons, '*b', 'markersize', 3);
  
  %plot_lats = plot(times(length(times)-size:length(times)), lats(length(times)-size:length(times)), '.g');
  %plot_lons = plot(times(length(times)-size:length(times)), lons(length(times)-size:length(times)), '.g');
  
  lat_p = polyfit(times(length(times)-size:length(times)),lats(length(times)-size:length(times)), degree);
  lon_p = polyfit(times(length(times)-size:length(times)),lons(length(times)-size:length(times)), degree);
 
  lat_f = polyval(lat_p, times(length(times)-size:length(times)));
  lon_f = polyval(lon_p, times(length(times)-size:length(times)));
  
  times = [times times(length(times)) + t];
    
  %plot(times(length(times)-size:length(times)),lat_f,'-r');
  %plot(times(length(times)-size:length(times)),lon_f,'-r');
  
  lat_predict = lat_f(length(lat_f));
  lon_predict = lon_f(length(lon_f));