function [best_pairs] = NCC(cornerA,A,cornerB,B,TH)
%Compute NCC between two images
%TH: Threshold

%initialize pairs
pairs = zeros(size(cornerA,1),5);
%window size
w = 5;
padsize = [(w-1)/2,(w-1)/2];
%padding image
pA = padarray(A,padsize,'replicate');
pB = padarray(B,padsize,'replicate');

for i = 1:size(cornerA,1)
    pos = cornerA(i,:);
    patchA = pA(pos(1):pos(1)+w-1,pos(2):pos(2)+w-1);
    mu = mean(patchA(:));
    %Normalize patch A
    temp = (patchA-mu) .* (patchA-mu);
    dist = sqrt(sum(temp(:)));
    NpatchA = (patchA - mu)./dist;
    max = -10000;
    for j = 1:size(cornerB,1)
        pos = cornerB(j,:);
        patchB = pB(pos(1):pos(1)+w-1,pos(2):pos(2)+w-1);
        mu = mean(patchB(:));
        %Normalize patch B
        temp = (patchB-mu) .* (patchB-mu);
        dist = sqrt(sum(temp(:)));
        NpatchB = (patchB - mu)./dist;
        %compute correlation
        cor = NpatchA .* NpatchB;
        cor = sum(cor(:));
        if max < cor
            max = cor;
            pairs(i,:) = [cornerA(i,:),cornerB(j,:),max];
        end
    end
end

%select pairs with NCC value > Threshold
best_pairs = zeros(numel(find(pairs(:,5)>TH)),5);
j = 0;
for i = 1:size(pairs,1)
    if (pairs(i,5) >= TH)
        j = j+1;
        best_pairs(j,:) = pairs(i,:);
    end
end

end

