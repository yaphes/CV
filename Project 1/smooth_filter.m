function [output] = smooth_filter(input,type,parameter)



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

        n = size(input,3);
        sig = parameter;
        for p = 1:n
        output(:,:,p) = imgaussfilt(input(:,:,p), sig);
        end
end    
