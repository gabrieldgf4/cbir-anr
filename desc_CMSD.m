

function hist = desc_CMSD(I, q1, q2, q3)
% Color Micro-Structure Descriptor 
%
% I - input image
% q1 - number of bins for the first image channel
% q2 - number of bins for the second image channel
% q3 - number of bins for the third image channel
%
% hist - final histogram
%
% Example:
% 
% hist = desc_CMSD(I, 8, 3, 3)
%
% Prepared by Gabriel da Silva Vieira (INF/UFG, IFGoiano - Brazil)
% August, 2022


I = norm_image(I);

[M,N,O] = size(I);
if O~= 3
    error('3 components are needed for histogram');
end

h = I(:,:,1);
s = I(:,:,2);
v = I(:,:,3);

H = h; S = s; V = v;

% h = h*360;

%    h quantified into Level q1;
maxH = max(h(:));
limitDown = -1;
limitUp = maxH/q1;
for i=1:q1
    H(h > limitDown & h <= limitUp + 0.001) = i-1;
    limitDown = limitUp;
    limitUp = limitUp + (maxH/q1); 
end

%    s quantified into Level q2;
maxS = max(s(:));
limitDown = -1;
limitUp = maxS/q2;
for i=1:q2
    S(s > limitDown & s <= limitUp + 0.001) = i-1;
    limitDown = limitUp;
    limitUp = limitUp + (maxS/q2);
end

%    v quantified into Level q3;
maxV = max(v(:));
limitDown = -1;
limitUp = maxV/q3;
for i=1:q3
    V(v > limitDown & v <= limitUp + 0.001) = i-1;    
    limitDown = limitUp;
    limitUp = limitUp + (maxV/q3);
end

% The three color components are combined into one-dimensional typical vector: 
% L = H * qs * qv + s * qv + v; QS, QV is the number of quantization levels of 
% S and V, L value range [0,71]
% Take QS = 3; QV = 3
L=zeros(M,N);
for  i = 1:M
    for j = 1:N
        L(i,j) = q2*q3*H(i,j) + q3*S(i,j) + V(i,j);
    end
end

M = L;

lenVector = q1 * q2 * q3;

%Count the frequencies 
HA=zeros(1,lenVector);
for i = 0:lenVector - 1
    HA(i+1) = size(find(M==i),1);
end

M = padarray(M, [1, 1], 0, 'both');
[h, w, ~] = size(M);


MS = zeros(1, lenVector);
for i=2:h-1
    for j=2:w-1
        win = M(i-1:i+1, j-1:j+1);
        center = M(i,j);
        
        TE1 = sum(sum(win == center)) - 1; % -1 to remove the matching with the center of the image
        
        MS(center+1) = MS(center+1) + TE1;
    end
end

% the feature vector
eps = 10^(-6); % very small constant 
hist = MS ./ (8 * HA + eps);


end
