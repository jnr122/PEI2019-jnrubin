function [lat_predict, lon_predict, lat_actual, lon_actual, accuracy] = mermaid_plot(float_name)
  % [data] = MERMAID_PLOT(float_name)
  %
  % This function recieves the name of a float and plots its last
  % 30 locations, and predicts its trajectory
  % 
  % Prediction time can be adjusted, but currently is is calculated as the 
  % average time between dives of the recent events
  %
  % Input: float_name (the id of the float)
  % Output: lat_predict, lon_predict, lat_actual, lon_actual (actual lat lon vs predicted)
  %         distance between actual and predicted coords (m)
  %
  % Last modified by Jonah Rubin, 6/21/19

  % pull data
  raw_data = webread(strcat('http://geoweb.princeton.edu/people/simons/SOM/', float_name, '_030.txt')); 
  data = (strsplit(raw_data, '\n'));
  
  data_points = [];
  surface_entries = [];
  diving_entries = [];
  clf;
			    
  % set up map
  figure(1);
  title(strcat(float_name, ': last 30 locations'));
  xlabel('Latitude');
  ylabel('Longitude');
  hold on;
  grid on;
  % make float structs, plot
  for i = 1:length(data)-1

    entry = data(i);
    split_entry = strsplit(entry{1});
   
    float.name = cell2mat(split_entry(1));
    float.lon  = str2double(split_entry(4)); 
    float.lat  = str2double(split_entry(5));
    float.loc  = geopoint(str2double(split_entry(4)), str2double(split_entry(5)));
    date = char(split_entry(2));
    time = char(split_entry(3));  
    date_time = [date, ' ',time];
    float.date_time = datetime(date_time);
    
    if i == length(data)-1
        marker_color = [0.0 0.6 0.6];
    else 
        marker_color = [(1-i/length(data)), (1-i/length(data)), (1-i/length(data))];
    end
    if i == 1
      float.leg_length = 0;
      float.leg_time = 0;
      float.leg_velocity = 0;
      float.leg_acceleration = 0;
    else
      float.leg_length = haversine(data_points(i-1).lat, data_points(i-1).lon, float.lat, float.lon);    
      float.leg_time = abs(datenum(float.date_time - data_points(i-1).date_time) * 24 * 3600); % convert to seconds;
      float.leg_velocity = float.leg_length/float.leg_time;
	  float.leg_acceleration = (float.leg_velocity - data_points(i-1).leg_velocity)/float.leg_time;
      if float.leg_time > 20000
		diving_entries = [diving_entries float];
	    plot_map = plot(float.lat,float.lon, 'color', marker_color,'marker','.','markersize', 15);
      else 
	    surface_entries = [surface_entries float];
	    plot_map = plot(float.lat,float.lon, 'color', marker_color,'marker','.','markersize', 15);
      end
    end
    
    data_points = [data_points, float];
  
  end

  regression_size = 2;
  regression_degree = 1;
    
  avg_surface_velocity = mean([surface_entries(length(surface_entries)-regression_size:(length(surface_entries))).leg_velocity]);
  avg_diving_velocity  = mean([diving_entries(length(diving_entries)-regression_size:(length(diving_entries))).leg_velocity])
  avg_surface_dist     = mean([surface_entries(length(surface_entries)-regression_size:(length(surface_entries))).leg_length]);
  avg_diving_dist      = mean([diving_entries(length(diving_entries)-regression_size:(length(diving_entries))).leg_length]);
  
  avg_surface_time = avg_surface_dist / avg_surface_velocity;
  avg_diving_time = avg_diving_dist / avg_diving_velocity;
  
  predicton_time = avg_diving_time;
  
  [lat_predict, lon_predict] = latlon_tseries([diving_entries.lat], [diving_entries.lon], [diving_entries.date_time], regression_size, predicton_time, regression_degree);

  lat_actual = data_points(length(data_points)).lat;
  lon_actual = data_points(length(data_points)).lon;
  
  predict = plot(lat_predict,lon_predict,'*r', 'markersize', 8);

  plot_map(1) = plot(NaN,NaN,'sk', 'markersize', 6);
  plot_map(2) = plot(NaN,NaN,'.k', 'markersize', 15);
  plot_map(3) = plot(NaN,NaN,'--r', 'markersize', 15);
  plot_map(4) = plot(NaN,NaN,'*r', 'markersize', 8);
  plot_map(5) = plot(NaN,NaN,'.', 'color', [0.0 0.6 0.6], 'markersize', 10);
  legend(plot_map, 'Oldest','Latest','Predicted Trajectory', 'Predicted Surface at t', 'Actual Next Surface');
  
  accuracy = haversine(lat_predict, lon_predict, lat_actual, lon_actual)
