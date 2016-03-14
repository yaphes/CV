function [ corner ] = harrisCornerDetector(I,k,quality)
% use Harris corner detector to return corner matrix
% default window: fspecial('gaussian',[5 1],1.5);
% sensitivity factor k, smaller k means sharper corner
% quality: detected corner quality

smooth_filter = fspecial('gaussian',[5 1],1.5);
w = smooth_filter * smooth_filter';

I = double(I);

A = imfilter(I,[-1 0 1],'replicate','same','conv');
B = imfilter(I,[-1 0 1]','replicate','same','conv');

%keep valid gradients
A = A(2:end-1,2:end-1);
B = B(2:end-1,2:end-1);

%calculate three matrices
C = A.*B;
A = A.*A;
B = B.*B;


%filter three matrices with smooth window
A = imfilter(A,w,'replicate','full','conv');
B = imfilter(B,w,'replicate','full','conv');
C = imfilter(C,w,'replicate','full','conv');

%crop to image size
A = A(2:end-1,2:end-1);
B = B(2:end-1,2:end-1);
C = C(2:end-1,2:end-1);

%calculate R function matrix
%R = det(M) - k*(trace(M)^2)
corner = (A .* B) - (C .^ 2) - k * ( A + B ) .^ 2;

%non maximum suppression
%delete edges and flat area
corner(corner<max(corner(:))*quality) = 0;
%computes regional maximum location
BW = imregionalmax(corner,8);
%'thin' corners
corner = bwmorph(BW,'shrink',Inf);

end


