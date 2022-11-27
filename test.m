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


%% Show the results
% Wrong responses are surrounded by red bounding boxes. 
% The visualization code where prepared to only work with the number of
% retrieved images equal to 12.

queryIdx = 50;
cl = initialCluster(:,1:12);
query = imread(strcat(folder, "/", datasetLocalImages{queryIdx, 1}, "/", datasetLocalImages{queryIdx, 2}));

queryFeatures = cell2mat(datasetFeatures(queryIdx, :));

% precision and recall
precisionQuery = eval_precision(datasetLocalImages, datasetLocalImages{queryIdx}, cl(queryIdx, 1:12));
recallQuery = eval_recall(datasetLocalImages, datasetLocalImages{queryIdx}, cl(queryIdx, 1:12));

% check what answer is correct ant what is wrong
for i=1:12 % length(cl(queryIdx, :))
    if strcmp(datasetLocalImages{queryIdx}, datasetLocalImages{cl(queryIdx, i)})
        hits_fails(i) = 1; % hits receives 1
    else
        hits_fails(i) = 0; % fails receives 0
    end
end

% call the subtightplot function
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.01], [0.1 0.01], [0.1 0.08]);
if ~make_it_tight,  clear subplot;  end

figure;

subplot(6,6,1);
axis off
text(0,0.1,{'\bf{Query Image:}'}, 'FontSize',14, 'Units','normalized');

subplot(6,6,7)
imagesc(query); axis off

subplot(6,6,13);
axis off
text(0,0.5,{'\bf{Retrieved Images:}'}, 'FontSize',14, 'Units','normalized');


for i=1:size(cl,2)
    retrievedImg = imread(strcat(folder, "/", datasetLocalImages{cl(queryIdx, i),1},...
        "/", datasetLocalImages{cl(queryIdx, i), 2}));
    
    [h, w] = size(retrievedImg);
    % insert a red bounding box in incorrect answers
    if hits_fails(i) == 0
%         retrievedImg = insertShape(retrievedImg,"rectangle",[1 1 w h],...
%             'LineWidth', 16, 'Color', [255 0 0]);
        
        r = retrievedImg(:,:,1); g = retrievedImg(:,:,2); b = retrievedImg(:,:,3);
        
        linWidth = 10;
        r(1:linWidth,:) = 255; r(end-linWidth:end,:) = 255; r(:,1:linWidth) = 255; r(:,end-linWidth:end) = 255;
        g(1:linWidth,:) = 0; g(end-linWidth:end,:) = 0; g(:,1:linWidth) = 0; g(:,end-linWidth:end) = 0;
        b(1:linWidth,:) = 0; b(end-linWidth:end,:) = 0; b(:,1:linWidth) = 0; b(:,end-linWidth:end) = 0;  
        
        retrievedImg = cat(3,r,g,b);
    end
       
    % class and predicted class
    subplot(6,6,i+18);
    caption = sprintf("Class=%s, y=%s", ...
        datasetLocalImages{queryIdx,1}, datasetLocalImages{cl(queryIdx, i), 1});
    
    imagesc(retrievedImg); axis off;   
    title(caption);
    
end

subplot(6,6,31);
axis off
precisionQueryStr = sprintf('%1.2f', precisionQuery);
recallQueryStr = sprintf('%1.2f', recallQuery);
text(0,0.3,{'\bf{Precision}: ' precisionQueryStr 'Recall: ' recallQueryStr}, 'FontSize',14, 'Units','normalized');

set(gcf, 'WindowState', 'maximized');

%%
fprintf('#### Precision and Recall before ANR #### \n')

fprintf('Precision: %1.4f\nRecall: %1.4f\n',...
    precisionQuery, recallQuery);


%% ANR - accuracy noise reduction

numOfResults = 12;
finalCluster = accuracy_noise_reduction( initialCluster, numOfResults );


%% Replace duplicate entries

finalCluster = replace_duplicate_entries(finalCluster, numOfResults, initialCluster);


%% Show the results
% Wrong responses are surrounded by red bounding boxes. 
% The visualization code where prepared to only work with the number of
% retrieved images equal to 12.

queryIdx = 50;
cl = finalCluster(:,1:12);
query = imread(strcat(folder, "/", datasetLocalImages{queryIdx, 1}, "/", datasetLocalImages{queryIdx, 2}));

queryFeatures = cell2mat(datasetFeatures(queryIdx, :));

% precision and recall
precisionQuery = eval_precision(datasetLocalImages, datasetLocalImages{queryIdx}, cl(queryIdx, 1:12));
recallQuery = eval_recall(datasetLocalImages, datasetLocalImages{queryIdx}, cl(queryIdx, 1:12));

% check what answer is correct ant what is wrong
for i=1:12 % length(cl(queryIdx, :))
    if strcmp(datasetLocalImages{queryIdx}, datasetLocalImages{cl(queryIdx, i)})
        hits_fails(i) = 1; % hits receives 1
    else
        hits_fails(i) = 0; % fails receives 0
    end
end

% call the subtightplot function
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.01], [0.1 0.01], [0.1 0.08]);
if ~make_it_tight,  clear subplot;  end

figure;

subplot(6,6,1);
axis off
text(0,0.1,{'\bf{Query Image:}'}, 'FontSize',14, 'Units','normalized');

subplot(6,6,7)
imagesc(query); axis off

subplot(6,6,13);
axis off
text(0,0.5,{'\bf{Retrieved Images:}'}, 'FontSize',14, 'Units','normalized');


for i=1:size(cl,2)
    retrievedImg = imread(strcat(folder, "/", datasetLocalImages{cl(queryIdx, i),1},...
        "/", datasetLocalImages{cl(queryIdx, i), 2}));
    
    [h, w] = size(retrievedImg);
    % insert a red bounding box in incorrect answers
    if hits_fails(i) == 0
%         retrievedImg = insertShape(retrievedImg,"rectangle",[1 1 w h],...
%             'LineWidth', 16, 'Color', [255 0 0]);
        
        r = retrievedImg(:,:,1); g = retrievedImg(:,:,2); b = retrievedImg(:,:,3);
        
        linWidth = 10;
        r(1:linWidth,:) = 255; r(end-linWidth:end,:) = 255; r(:,1:linWidth) = 255; r(:,end-linWidth:end) = 255;
        g(1:linWidth,:) = 0; g(end-linWidth:end,:) = 0; g(:,1:linWidth) = 0; g(:,end-linWidth:end) = 0;
        b(1:linWidth,:) = 0; b(end-linWidth:end,:) = 0; b(:,1:linWidth) = 0; b(:,end-linWidth:end) = 0;  
        
        retrievedImg = cat(3,r,g,b);
    end
       
    % class and predicted class
    subplot(6,6,i+18);
    caption = sprintf("Class=%s, y=%s", ...
        datasetLocalImages{queryIdx,1}, datasetLocalImages{cl(queryIdx, i), 1});
    
    imagesc(retrievedImg); axis off;   
    title(caption);
    
end

subplot(6,6,31);
axis off
precisionQueryStr = sprintf('%1.2f', precisionQuery);
recallQueryStr = sprintf('%1.2f', recallQuery);
text(0,0.3,{'\bf{Precision}: ' precisionQueryStr 'Recall: ' recallQueryStr}, 'FontSize',14, 'Units','normalized');

set(gcf, 'WindowState', 'maximized');


%%
fprintf('#### Precision and Recall after ANR #### \n')

fprintf('Precision: %1.4f\nRecall: %1.4f\n',...
    precisionQuery, recallQuery);


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
