clear all

%%Store image sequence in a 3 dimension array
%%Also translate rgb into grayscale
FOLDER = 'RedChair';  %original image folder
sequence = Read_Sequence(FOLDER);

%%Smooth the image
smoothed = smooth_filter(sequence,'gaussian',1.4);

%%Filter the image
filtered = tempo_filter(smoothed,'gaussian');
n = size(filtered,3);

%%Threshold filtered image
TH = 10;  %Threshold value
mask = zeros(size(filtered));
for p = 1:n
    temp = filtered(:,:,p);
    temp(abs(filtered(:,:,p))>=TH) = 1;
    temp(abs(filtered(:,:,p))<TH) = 0;
    mask(:,:,p) = temp;
end

%%Mask the original image
dirOutput = dir(fullfile(FOLDER,'*.jpg'));
fileNames = {dirOutput.name}';
numFrames = numel(fileNames);

for p = 1:numFrames
    I = imread(fullfile(FOLDER,fileNames{p}));
    temp = I(:,:,1);
    temp(mask(:,:,p)==1) = 255; %Red contour
    I(:,:,1) = temp;
    temp = I(:,:,2);
    temp(mask(:,:,p)==1) = 0;
    I(:,:,2) = temp;
    temp = I(:,:,3);
    temp(mask(:,:,p)==1) = 0;
    I(:,:,3) = temp;
    imwrite(I,fullfile('Output',FOLDER,fileNames{p}));
end
