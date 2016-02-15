function [th] = select_threshold(input)
%Automatically select threshold

sample = input(1:30,1:30) .* input(1:30,1:30);
n = numel(sample);
v = 1/n * sum(sample(:));
th = 5*sqrt(v);


