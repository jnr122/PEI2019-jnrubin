function [lat_predict, lon_predict] = latlon_tseries(lats, lons, times, size ,t, degree)
  % [lat_predict, lon_predict] = LATLON_TSERIES(events)
  %
  % This function plots lat and lon arrays as separate time series
  % For backtesting, backtest_num refers to the number of float events to
  % go backwards for testing
  % 
  %
  % Input: lats, lons, times (corresponding lat, lon, and time arrays)
  %        size (the number of datapoints to use for the regression)
  %        t (the number of seconds since last report to retrieve prediction)
  %        degree (degree of polynomial regression)
  %
  % Output: lat_predict, lon_predict (predicted lat lon at given time)
  %
  % Last modified by Jonah Rubin, 6/21/19
  
  figure(2)
  title('Lat Lon Timeseries');
  xlabel('time (seconds)'); 
  ylabel('displacement (degrees)');
  hold on;
  grid on;
  
  % (array - n) allows testing on known data
  % scale arrays to only use alotted size
  backtest_num = 1;
  times = times(length(times)-size:(length(times)-backtest_num));
  times = datenum(times) * 24 * 3600;
  
  lons = lons(length(lons)-size:(length(lons)-backtest_num));
  lats = lats(length(lats)-size:(length(lats)-backtest_num));

  lat_data = plot(times, lats, '+k', 'markersize', 3);
  lon_data = plot(times, lons, '*b', 'markersize', 3);
  
  % polyfit to scaled arrays
  lat_p = polyfit(times,lats, degree);
  lon_p = polyfit(times,lons, degree);
 
  % make polyval arrays
  lat_f = polyval(lat_p, times);
  lon_f = polyval(lon_p, times);

  % add point in time for approximation
  times = [times times(length(times)) + t];
  
  % run approximation time through the poly fit
  lat_f = [lat_f polyval(lat_p, times(length(times)) + t)];
  lon_f = [lon_f polyval(lon_p, times(length(times)) + t)];
  
  % graph polyfits
  plot(times,lat_f,'-r');
  plot(times,lon_f,'-r')
  
  lat_predict = lat_f(length(lat_f));
  lon_predict = lon_f(length(lon_f));

  plot_map(1) = plot(NaN,NaN,'db', 'markersize', 6);
  plot_map(2) = plot(NaN,NaN,'+k', 'markersize', 6);
  plot_map(4) = plot(NaN,NaN,'-r', 'markersize', 3); 
  legend('Longitude','Latitude','Extended Polyfit');
  
  figure(1)
  plot(lat_f,lon_f,'--r', 'LineWidth', 2);

