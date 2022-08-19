

function out = norm_image(I)

I = double(I);

[h, w, channels] = size(I);

out = nan(h, w, channels);

eps = 10^(-6); % very small constant 
for i=1:channels
    minC = min(min(I(:,:,i)));
    maxC = max(max(I(:,:,i)));
    
    out(:,:,i) = (I(:,:,i) - minC) ./ (maxC - minC) + eps;
end


end
