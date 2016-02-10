function [sequence] = Read_Sequence(foldername)
%Read image sequence 

%Scan folder
dirOutput = dir(fullfile(foldername,'*.jpg'));
fileNames = {dirOutput.name}';
numFrames = numel(fileNames);

%Create mXnXnum array to store images sequence
I = rgb2gray(imread(fullfile(foldername,fileNames{1})));
sequence = zeros([size(I) numFrames],class(I));
sequence(:,:,1) = I;

for p = 2:numFrames
    sequence(:,:,p) = rgb2gray(imread(fullfile(foldername,fileNames{p})));
end


