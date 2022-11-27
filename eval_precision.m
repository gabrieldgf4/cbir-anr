
function precision = eval_precision(datasetLocalImages, localQueryImg, indexes)

% Calculate precison of the CBIR system
%
% Precision is defined as the fraction of images retrieved that are relevant 
% (belong to the same class as the query)
%
% datasetLocalImages - folder and name of the image in the dataset
% localQueryImg - folder and name of the query image
% indexes - positions of the retrieved image in the dataset related to the
% query image
%
% Example:
%
% precision = eval_precision(datasetLocalImages, localQueryImages{queryIdx}, indexes);
%
% Prepared by Gabriel da Silva Vieira (INF/UFG, IFGoiano - Brazil)
% August, 2022


% query image
x = localQueryImg;

count = 0;
for i=1:length(indexes)
    % retrieved image
    y = datasetLocalImages{indexes(i)};

    if isstring(x) && isstring(y)
        % check if retrieved image (y) class is equal to the query image (x)
        if strcmp(x, y)
            count = count + 1;
        end
    elseif isIntegerValue(x) && isIntegerValue(y)
        % check if retrieved image (y) class is equal to the query image (x)
        if x == y
            count = count + 1;
        end
    else
        error("x and y must be integers or character arrays");
    end
    
end

precision = count / length(indexes);

end

function T = isIntegerValue(X)
    T = (mod(X, 1) == 0);
end