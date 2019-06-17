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

raw_data = webread('http://geoweb.princeton.edu/people/simons/SOM/P017_030.txt');
data = strsplit(raw_data, '\n')

x = data(1)
