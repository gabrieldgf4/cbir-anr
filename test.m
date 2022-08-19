%
% % Gabriel da Silva Vieira (INF/UFG, IFGoiano (BRAZIL) - 2022)
%

%% Construct the feature vector space from a dataset

folder = "Corel-1k";
ext = "jpg";

[datasetFeatures, datasetLocalImages, descriptorEndPosition, qttyImagesFolder] =...
    feature_space_construction(folder, ext);


%% Initial cluster

totalDatasetImages = sum(qttyImagesFolder);

initialCluster = [];
distancesAllSorted = [];
distancesAll = [];

for ii=0:(length(qttyImagesFolder) - 1)
    % class 0,1,2,...
    class = ii;
    totalClassImages = qttyImagesFolder(ii+1);
    startQuery = (class * totalClassImages) + 1;
    endQuery = startQuery + (totalClassImages - 1);
    
    count = 1;
    for i=startQuery:endQuery
        
        % query image
        queryFeatures = cell2mat(datasetFeatures(i, :));
        [results, indexes, distances] = search_initial_image_retrieval(datasetFeatures, queryFeatures,...
            totalDatasetImages, descriptorEndPosition);
        
        % store results
        initialCluster = [initialCluster; indexes];
        distancesAllSorted = [distancesAllSorted; results];
        distancesAll = [distancesAll; distances];
    end
    
end


%% ANR - accuracy noise reduction

numOfResults = 12;
finalCluster = accuracy_noise_reduction( initialCluster, numOfResults );


%% Replace duplicate entries

finalCluster = replace_duplicate_entries(finalCluster, numOfResults, initialCluster);


%% show results
queryIdx = 328;
query = imread(strcat(folder, "/", datasetLocalImages{queryIdx, 1}, "/", datasetLocalImages{queryIdx, 2}));
figure; imagesc(query);
title("Query Image");

queryFeatures = cell2mat(datasetFeatures(queryIdx, :));

for i=1:size(finalCluster,2)
    retrievedImg = imread(strcat(folder, "/", datasetLocalImages{finalCluster(queryIdx, i),1},...
        "/", datasetLocalImages{finalCluster(queryIdx, i), 2}));
    figure; imagesc(retrievedImg);
    caption = sprintf("Class=%s, y=%s, d=%d", ...
        datasetLocalImages{queryIdx,1}, datasetLocalImages{finalCluster(queryIdx, i), 1}, ...
            distancesAll(queryIdx, finalCluster(queryIdx, i)));
    title(caption);
end