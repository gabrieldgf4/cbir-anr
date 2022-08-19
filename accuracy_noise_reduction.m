

function cluster = accuracy_noise_reduction(indexesAll, numOfResults)
%
% Reorganize the original cluster considering its first retrieved values
%
% indexesAll - original cluster
% numOfResults - the number of images to be returned
%
% Example
% cluster = accuracy_noise_reduction(indexesAll, 12)
%
% Prepared by Gabriel da Silva Vieira (INF/UFG, IFGoiano - Brazil)
% August, 2022


cluster = indexesAll(:,1:2);
numOfFirstIdxs = round(numOfResults / 2);
% numOfFirstIdxs = numOfResults;

[h, ~] = size(indexesAll);
temp = 1:h;

for i=1:h
    % prepare a small cluster (firstIdxs) considering only the first images of the original
    % cluster
    firstIdxs = indexesAll(i, 2:numOfFirstIdxs);
    
    for j=1:numOfFirstIdxs
        firstIdxs = [ firstIdxs indexesAll(firstIdxs(j), 2:numOfFirstIdxs) ];
    end
    
    firstIdxs = unique(firstIdxs, 'stable');
    
    % check where the first and second retrieved images of a row is in the
    % small cluster
    soma = [];
    for j=1:length(firstIdxs) 
        logicalIdx = ( indexesAll(firstIdxs(j),:) == indexesAll(i,1) );
        idx1 = temp(logicalIdx);
        
        logicalIdx = ( indexesAll(firstIdxs(j),:) == indexesAll(i,2) );
        idx2 = temp(logicalIdx);
        
        somaIdxs = idx1+idx2;
        if somaIdxs == 3 % check mirroring
            soma(j) = 10000; % a large value
        else
            soma(j) = somaIdxs;
        end
    end    
    
    % sort the results
    [~, indexes] = sort(soma);   
    
    % get the first and second images from the sorted indexes
    cont = 3;
    for j=1:(numOfFirstIdxs - 1)
        cluster(i,cont:cont+1) = indexesAll(firstIdxs(indexes(j)),1:2);
        cont = cont+2;
    end

end

end
