%Project 2
clear all

%Set two source images
%left photo comes to A, right photo comes to B
ImageA = imread('DanaHallWay1/DSC_0282.jpg');
ImageB = imread('DanaHallWay1/DSC_0283.jpg');

%resize scale factor
scale = 1;
A = imresize(ImageA,1);
B = imresize(ImageB,1);

%RGB -> GRAY
A = double(rgb2gray(A));
B = double(rgb2gray(B));

%detect corners in two images
cornerA = harrisCornerDetector(A,0.05,0.01);
cornerB = harrisCornerDetector(B,0.05,0.01);

[r,c] = find(cornerA);
cornerA = [r,c];
[r,c] = find(cornerB);
cornerB = [r,c];

%compute NCC between two images, mapping image B to image A
%transfer coordinates: x = column, y = row
pairs = NCC(cornerB,B,cornerA,A,0.95);
temp = pairs;
pairs(:,1:4) = temp(:,[2 1 4 3]);

% imshow(B,[]);
% hold on
% plot(pairs(:,1),pairs(:,2),'*');
% figure;
% imshow(A,[]);
% hold on
% plot(pairs(:,3),pairs(:,4),'*');

%compute best homography use RANSAC
homography = RANSAC(pairs,4,size(pairs,1)*2,0.4,100);

%warp two images
h = inv(homography);
[xi,yi] = meshgrid(-100:size(A,2)*2,-100:size(A,1)+100);
xx = (h(1,1)*xi+h(1,2)*yi+h(1,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));
yy = (h(2,1)*xi+h(2,2)*yi+h(2,3))./(h(3,1)*xi+h(3,2)*yi+h(3,3));

blend = zeros([size(xx),3]);
for i=1:3
    %warped image
    foo = uint8(interp2(double(ImageB(:,:,i)),xx,yy));
    %original image
    foo2 = uint8(interp2(double(ImageA(:,:,i)),xi,yi));
%     [r,~] = find(yi>0);
%     [~,c] = find(foo(r(1),:)>0);
%     foo(:,1:c) = 0;
%     foo2(:,c+1:end) = 0;
    overlay = (foo > 0) & (foo2 > 0);
    foo(overlay) = 0;
    %foo2(overlay) = foo2(overlay)/2;
    foo3 = foo2 + foo;
    blend(:,:,i) = foo3;
end
blend = uint8(blend);
imshow(blend);