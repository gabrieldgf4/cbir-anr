#  CBIR-ANR: Contet-Based Image Retrieval with an Accuracy Noise Reduction approach

Efficient algorithms, intelligent approaches, and intensive use of computers are crucial to extracting reliable information from large-scale dataset. Then, we introduce a new image descriptors integration to represent the visual attributes of images. In our proposal, color intensity values are organized in histograms (cl-MSD descriptor), image contrast is encoded through local variance directional responses (LDiPv descriptor), and local binary patterns are used to represent the spatial arrangement of color in image regions (LBP descriptor). Also, we present a novel accuracy noise reduction approach based on clustering the initial responses of the image matching process.

<!-- ![alt tag](https://user-images.githubusercontent.com/63321757/185625922-22089398-9f30-4c58-8ff7-4ac7d4e99a4a.png) -->


# Software

Construct the feature vector space from a dataset:

    [datasetFeatures, datasetLocalImages, descriptorEndPosition, qttyImagesFolder] =...
    feature_space_construction(folder, ext);

CBIR - Initial cluster:

    [~, initialCluster, ~] = search_initial_image_retrieval(datasetFeatures, queryFeatures,...
            totalDatasetImages, descriptorEndPosition);
            
See the results:
    
    XXX
    
ANR - accuracy noise reduction

    numOfResults = 12;
    finalCluster = accuracy_noise_reduction( initialCluster, numOfResults );
    
See the results after ANR:

    XXX

# Code
You can download the code by:

    git clone https://github.com/gabrieldgf4/cbir-anr.git
    cd cbir-anr
    
    Then, open MATLAB and execute the file "test.m"
