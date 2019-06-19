function [data] = mermaid_plot(float_name)
  % [data] = MERMAID_PLOT(float_name)
  %
  % This function recieves the name of a float and plots its last
  % 30 locations, and predicts its trajectory
  %
  % Input: float_name (the id of the float)
  % Output: data (the location data of the float)
  %
  % Last modified by Jonah Rubin, 6/18/19

  % pull data
  raw_data = webread(strcat('http://geoweb.princeton.edu/people/simons/SOM/', float_name, '_030.txt'));
  data = strsplit(raw_data, '\n');
  data_points = [];
  regress_velocity = [];
  regress_time = [];
  regress_points = 4;
  clf;
			    
  % set up map
  figure(1);
  title(strcat(float_name, ': last 30 locations'));
  xlabel('Latitude');
  ylabel('Longitude');
  hold on;

  % make float structs, plot
  for i = 1:length(data)-1
    entry = data(i);
    split_entry = strsplit(entry{1});
   
    float.name = cell2mat(split_entry(1));
    float.lat  = str2double(split_entry(4));
  
    float.long  = str2double(split_entry(5)); 
    float.loc  = geopoint(str2double(split_entry(4)), str2double(split_entry(5)));
    date = char(split_entry(2));
    time = char(split_entry(3));  
    date_time = [date, ' ',time];
    float.date_time = datetime(date_time);

    if i == 1
      float.leg_length = 0;
      float.leg_time = 0;
      float.leg_velocity = 0;
    else
      float.leg_length = haversine(data_points(i-1).lat, data_points(i-1).long, float.lat, float.long);    
      float.leg_time = datenum(float.date_time - data_points(i-1).date_time) * 24 * 3600; % convert to seconds;
      float.leg_velocity = float.leg_length/float.leg_time;
    end

    if (length(data) - 25) <= regress_points
      regress_velocity = [regress_velocity, float.leg_velocity]
      if (length(data) - 25) == regress_points
        regress_time = [regress_time, 0]
      else
        regress_time = [regress_time, regress_time(length(regress_time)) + float.leg_time]
      end
    end
    data_points = [data_points, float];
    plot_map = plot3(float.lat,float.long, 2600, 'color', [i/length(data) i/length(data) i/length(data)],'marker','.','markersize', 15);
    
  end
			    
  % make legend
  plot_map(1) = plot(NaN,NaN,'sk', 'markersize', 6);
  plot_map(2) = plot(NaN,NaN,'.k', 'markersize', 15);
  plot_map(3) = plot(NaN,NaN,'.r', 'markersize', 15);
  legend(plot_map, 'Oldest','Latest','Prediction');

  



	    
  
  













			 
