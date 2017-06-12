function [ S ] = exp_smooth( X, alpha )
% Smooths the input signal columnwise using exponential function
    
    S = zeros(size(X,1), size(X, 2)+1);
    S(:,1) = X(:,1);
    for i=1:size(X,2)
        S(:,i+1) = alpha * X(:,i) + (1 - alpha) * S(:,i);
    end
    
    S = S(:,2:end);
end

