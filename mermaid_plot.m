function [data] = mermaid_plot(float_name)
% [data] = MERMAID_PLOT(float_name)
%
% This function recieves the name of a float and plots its last
% 30 locations, and predicts its trajectory
%
% Input: float_name (the id of the float)
% Output: data (the location data of the float)
%
% Last modified by Jonah Rubin, 6/17/19

raw_data = webread(strcat('http://geoweb.princeton.edu/people/simons/SOM/', float_name, '_030.txt'));
data = strsplit(raw_data, '\n');

data_points = [];

figure(1)
title(strcat(float_name, ': last 30 locations'))
xlabel('Latitude')
ylabel('Longitude')

hold on

for i = 1:length(data)-1
   entry = data(i);
   split_entry = strsplit(entry{1});
   
   float.name = cell2mat(split_entry(1));
   float.lat  = str2double(split_entry(4));
  
   float.long  = str2double(split_entry(5)); 
   float.loc  = geopoint(str2double(split_entry(4)), str2double(split_entry(5)));
   float.date = split_entry(2);
   float.time = split_entry(3); 
 
   data_points = [data_points, float];
   geoshow(float.loc)
end

