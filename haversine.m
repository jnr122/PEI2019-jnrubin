function [d]=haversine(lat1,lon1,lat2,lon2)
  % function [d]=HAVERSINE(lat1,lon1,lat2,lon2)
  %
  % Computes the great circle distance between two lat/lon pairs
  %
  % Input: lat lon pairs as specified
  % Ouput: GSD in km
  %
  % Last modified by Jonah Rubin 6/18/19
  
  dlat = deg2rads(lat2-lat1);
  dlon = deg2rads(lon2-lon1);
  lat1 = deg2rads(lat1);
  lat2 = deg2rads(lat2);
  a = (sin(dlat./2)).^2 + cos(lat1) .* cos(lat2) .* (sin(dlon./2)).^2;
  c = 2 .* asin(sqrt(a));
  d = 6372.8 * c; 

end
