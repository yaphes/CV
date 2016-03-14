function [H] = computeHomo(sample,num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
A = zeros(2*num,9);
A(1:2:2*num,:) = [sample(:,[1 2]),ones(num,1),zeros(num,3),...
    -sample(:,[1 2]).*repmat(sample(:,3),1,2),-sample(:,3)];
A(2:2:2*num,:) = [zeros(num,3),sample(:,[1 2]),ones(num,1),...
    -sample(:,[1 2]).*repmat(sample(:,4),1,2),-sample(:,4)];
[evec,~] = eig(A'*A);
H = reshape(evec(:,1),[3,3])';

end

