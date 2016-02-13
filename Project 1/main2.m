clear all

%%Store image sequence in a 3 dimension array
%%Also translate rgb into grayscale
FOLDER = 'EnterExitCrossingPaths2cor';  %original image folder
sequence = Read_Sequence(FOLDER);

%%Smooth the image
smoothed = smooth_filter(sequence,'box',3);

%%Filter the image
frame = 100;
filtered = tempo_filter(smoothed,'gaussian',2.2,frame);

%%Threshold filtered image
TH = 15;  %Threshold value
mask = zeros(size(filtered));
mask(abs(filtered)>=TH) = 1;
mask(abs(filtered)<TH) = 0;

%%Mask the original image
dirOutput = dir(fullfile(FOLDER,'*.jpg'));
fileNames = {dirOutput.name}';
numFrames = numel(fileNames);

I = imread(fullfile(FOLDER,fileNames{frame}));
temp = I(:,:,1);
temp(mask==1) = 255; %Red contour
I(:,:,1) = temp;
temp = I(:,:,2);
temp(mask==1) = 0;
I(:,:,2) = temp;
temp = I(:,:,3);
temp(mask==1) = 0;
I(:,:,3) = temp;
imwrite(I,fullfile('Output',FOLDER,fileNames{frame}));


