function [homography] = RANSAC(pairs,num,iter,ratio,threshDist)
%RANSAC 
%pairs: points data, num: minimum number of fitted points, 
%iter: maximum number of iteration, ratio:threshold ratio of inliers

number = size(pairs,1); % Total number of points
bestInNum = 0; % Inliers number of best fitting model 
bestInlierIdx = 0; %Inliers indices of best fitting model
%bestHomography = zeros(3,3);
data = pairs(:,[1:4]);
for i=1:iter
    idx = randperm(number,num);
    sample = data(idx,:); %randomly pick num pairs of points
    %compute homography
    H = computeHomo(sample,num);
    %compute distance
    src = [data(:,[1 2])';ones(1,number)];
    dst = [data(:,[3 4])';ones(1,number)];
    predict = H*src;
    predict = predict./repmat(predict(3,:),3,1);
    distance = round(sum ((dst-predict).^2));
    inlierIdx = find(distance < threshDist);
    inlierNum = numel(inlierIdx);
    if (inlierNum > round(number*ratio) && inlierNum > bestInNum)
        bestInNum = inlierNum;
        bestInlierIdx = inlierIdx;
    end
end

%use all inliers to compute least square homography again
success = (sum(bestInlierIdx) ~= 0);
assert(success,'No best homography found, please run again');
    
srcInliers = src(1:2,bestInlierIdx)';
dstInliers = dst(1:2,bestInlierIdx)';
inliers = [srcInliers,dstInliers]; 
homography = computeHomo(inliers,size(inliers,1));
% src = [inliers(:,[1 2])';ones(1,bestInNum)];
% dst = [inliers(:,[3 4])';ones(1,bestInNum)];
% predict = homography*src;
% predict = predict./repmat(predict(3,:),3,1);
% distance = round(sum ((dst-predict).^2));
end


