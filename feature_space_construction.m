
function [datasetFeatures, datasetLocalImages, descriptorEndPosition, qttyImagesFolder] =...
    feature_space_construction(folder, ext)

% Prepare the feature space with all image into a dataset 
%
% folder - path of the image dataset
% ext - name of the extension of the images into the dataset
%
% datasetFeatures - feature vectors, one row for each image
% datasetLocalImages - name and image paths
% descriptorEndPosition - final position of each descriptor in the feature vector
% qttyImagesFolder - the number of images per folder, i.e., the number of
% images that represents a class
%
% Example:
% 
% folder = "datasets/Corel-1k";
% ext = "jpg";
% [datasetFeatures, datasetLocalImages, descriptorEndPosition, qttyImagesFolder] = feature_space_construction(folder, ext)
%
% Prepared by Gabriel da Silva Vieira (INF/UFG, IFGoiano - Brazil)
% August, 2022

% root directory
dirInfo = dir(folder);

dirInfo(~[dirInfo.isdir]) = [];  % remove non-directories
dirInfo(strcmpi({dirInfo.name}, {'.'})) = []; % remove the folder names "."
dirInfo(strcmpi({dirInfo.name}, {'..'})) = []; % remove the folder names ".."

% count the number of images into the dataset
imagesFolder = dir(fullfile(folder, strcat('**/*.', ext)));
qttyImages = length(imagesFolder);

% prepare the output data
nbins = [8 3 3]; % number of bins used in the CMSD descriptor
dimCMSD = 72; dimLBP = 59; dimLDiPv = 56; % CMSD = 72, LBP = 59, LDiPv = 56
datasetFeatures = zeros(qttyImages, dimCMSD+dimLBP+dimLDiPv);
datasetLocalImages = strings(qttyImages, 2);
qttyImagesFolder = zeros(length(dirInfo), 1);

% loop inside the subfolders
cont = 1;
for i=1:length(dirInfo)
    % name of the subfolder
    thisDir = convertCharsToStrings(dirInfo(i).name);
    
    % name of the images into the subfolder
    imageFiles = dir(fullfile(folder, thisDir, strcat("*.", ext)));
    nfiles = length(imageFiles);    % Number of files that were found (images)
  
    % loop over the images into the subfolder
    for j=1:nfiles
        fileName = convertCharsToStrings(imageFiles(j).name);
%         fileName = (imageFiles(j).name);
        currentfilename = strcat(imageFiles(j).folder, ('/'), fileName);

        % load an image
        img = imread(currentfilename);
        
        % convert images
        img_c1 = rgb2hsv(img);
        img_c2 = max(img,[],3);
        
        % CMSD - Color Micro-Structure Descriptor (Dimension - 72)
        cmsd = desc_CMSD(img_c1, nbins(1), nbins(2), nbins(3));

        % LBP - Local Binary Pattern (Dimension - 59)
        lbp = extractLBPFeatures(img_c2);

        % LDiPv - Local Directional Pattern Variance (Dimension - 56)
        ldipv = desc_LDiPv(img_c2);  

        % save the feature vectors and the image path and image names
        datasetFeatures(cont,:) = [cmsd, double(lbp), ldipv];
        datasetLocalImages(cont,:) = [thisDir, fileName];
        
        cont = cont+1;
       
    end
    
    % store the number of images into a folder, i.e., the number of images
    % of a class
    qttyImagesFolder(i) = nfiles;
    
end

% Convert the results to cell array
datasetFeatures = num2cell(datasetFeatures);
datasetLocalImages = num2cell(datasetLocalImages);

% Mark the final position of each descriptor in the feature vector
endDescriptor1 = dimCMSD;
endDescriptor2 = endDescriptor1 + dimLBP;
endDescriptor3 = endDescriptor2 + dimLDiPv;
descriptorEndPosition = [endDescriptor1, endDescriptor2, endDescriptor3];

end



