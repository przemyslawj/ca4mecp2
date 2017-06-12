function [ dF ] = dFOverF( F )
%Delta F over F base computed for a locally adjusted F base.
%   F base is a value of linear regression of the signal. This compensates
%   for gradual bleaching of the signal, and accumulating calcium inside
%   the cells.

dF = zeros(size(F));
for i=1:size(F,1)
    len = size(F,2);
    X = [ones(len,1), (1:len)'];
    A = regress(F(i,:)',X);
    y = A' * X';
    dF(i,:) = (F(i,:) - y) ./ y;
end

end

