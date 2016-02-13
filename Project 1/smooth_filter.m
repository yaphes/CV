function [output] = smooth_filter(input,parameter,type)



output = zeros(size(input));
input = double(input);

switch type
    case 'box'
        filterSize = parameter;
        n = size(input,3);
        for p = 1:n
           output(:,:,p) = imboxfilt(input(:,:,p),filterSize);
        end
    
    case 'guassian'
%         sig2 = 1.4 *1.4 ;
%         mask = zeros(7,7);
%         for x = -(round(5*sig2)-1)/2:(round(5*sig2)-1)/2
%         for y = -(round(5*sig2)-1)/2:(round(5*sig2)-1)/2
%         mask(x+4,y+4) = exp((-x*x - y*y)/(2 *sig2));
%         end
%         end
        n = size(input,3);
        sig = parameter;
        for p = 1:n
        output(:,:,p) = imgaussfilt(input(:,:,p), sig);
        end
end    