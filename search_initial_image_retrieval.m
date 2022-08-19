
function [results, indexes, distances] = search_initial_image_retrieval(datasetFeatures, ...
    queryFeatures, limit, descriptorEndPosition)

% Based on a query image, find its correlated images in the dataset
%
% datasetFeatures - pre-computed dataset features
% queryFeatures - pre-computed query image features
% limit - the number of results to be returned
% descriptorEndPosition - the ending of each descriptor in the feature
% vectors
%
% results - distances in ascending order
% indexes - image indexes, images related to the query image are in the first positions
% distances - distances between a query image and dataset images (it is not in ascending order)
%
% Example:
%
% [results, indexes, distances] = search_initial_image_retrieval(datasetFeatures, queryFeatures, 1000, [72 131 187]);
%
% Prepared by Gabriel da Silva Vieira (INF/UFG, IFGoiano - Brazil)
% August, 2022

[qttyFeatureLines, qttyVarDescriptors] = size(datasetFeatures);

% absolute difference between dataset and query
absDistances = zeros(qttyFeatureLines, qttyVarDescriptors);
for i=1:qttyFeatureLines 
    features = cell2mat(datasetFeatures(i,:));
    absDistances(i,:) = abs(features - queryFeatures);
end

% sum of the differences for each descriptor data
lenDescriptorPos = length(descriptorEndPosition);
sumDistances = zeros(qttyFeatureLines, lenDescriptorPos);
count = 1;
for i=1:lenDescriptorPos
    sumDistances(:, i) = sum(absDistances(:, count:descriptorEndPosition(i)), 2);
    count = descriptorEndPosition(i) + 1;
end

% normalize distances for each descriptor
sumDistances = sumDistances';
mind = min(sumDistances, [], 2);
maxd = max(sumDistances, [], 2);
normDistances = (sumDistances - mind) ./ (maxd - mind);

distances = ( sum(normDistances, 1) ) ./ lenDescriptorPos;

% sort the results
[results, indexes] = sort(distances);

% return the results
results = results(1:limit);
indexes = indexes(1:limit);

end





