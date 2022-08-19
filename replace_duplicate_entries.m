

function clusterOut = replace_duplicate_entries(clusterIn, numOfResults, indexesAll)
%
% Replace repeated values into the cluster
%
% ClusterIn - cluster with repeated values 
% numOfResults - the number of images to be returned
% indexesAll - retrieved images (initial cluster)
%
% Example
% cluster = replace_duplicate_entries(clusterIn, 12, indexesAll);
%
% Prepared by Gabriel da Silva Vieira (INF/UFG, IFGoiano - Brazil)
% August, 2022

[h, w] = size(clusterIn); 
clusterOut = clusterIn;

numOfIdxs = round(numOfResults / 2);
% numOfIdxs = round(numOfResults);

% check repetitions in clusterIn
checked1 = false(h, w);
for i=1:h
    verificado = zeros(1,w);
    for j=w:-1:1
        if verificado(j) == 0
            logicRepetitions = ( clusterIn(i,j) == clusterIn(i,:) );
            check = sum(logicRepetitions);
            if check > 1
                % change all repetitions
                [idx] = find(logicRepetitions==1); 
                logicRepetitions_copy = logicRepetitions;
                logicRepetitions_copy(idx(1)) = 0;
                checked1(i, logicRepetitions_copy) = 1;

                % if a value has 3 or more repetitions, change only the first one
%                 checked1(i,j) = 1;
            end
            verificado(logicRepetitions) = 1;
        end
    end
end

% for each row changed repeated values
for i=1:h
    % prepare a small cluster with the first indexes of the original
    % cluster
    smallCluster = [];
    for j=1:numOfIdxs
        smallCluster = [smallCluster; clusterIn(clusterIn(i,j),1:numOfIdxs)];
    end
    smallCluster = unique(smallCluster(:), 'stable');
    
   
    
    % check where the first and second retrieved images of a row is in the
    % small cluster
    soma = [];
    temp = 1:h;
    for j=1:length(smallCluster) 
        logicalIdx = ( indexesAll(smallCluster(j),:) == indexesAll(i,1) );
        idx1 = temp(logicalIdx);
        
        logicalIdx = ( indexesAll(smallCluster(j),:) == indexesAll(i,2) );
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
    
    smallCluster = smallCluster(indexes);
    
    
    % check for values in smallCluster that are not in clusterIn
    checked2 = false(1, w);
    for j=1:length(smallCluster)
        check = sum(smallCluster(j) == clusterIn(i,:));
        if check == 0
            checked2(j) = 1;
        end
    end
    
    % change repeated values in clusterIn by values in smallCluster
    checked2_copy = checked2;
    for j=1:w
        if checked1(i,j) == 1
            if sum(checked2_copy(:)) > 0
                cluster2Idx = smallCluster(checked2_copy);
                clusterOut(i,j) = cluster2Idx(1);

                temp = 1:length(checked2_copy);
                tempIdx = temp(checked2_copy(:));
                checked2_copy(tempIdx(1)) = false;
            else
                break;
            end
        end
    end

end

end
