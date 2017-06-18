function [ dF ] = dFOverF( F )
%Delta F over F base computed for a locally adjusted F base.
%   F base is a value of linear regression of the signal. This compensates
%   for gradual bleaching of the signal, and accumulating calcium inside
%   the cells.

dF = zeros(size(F));
for i=1:size(F,1)
    Fbase = smooth(F(i,:),0.3,'lowess')';
    dF(i,:) = (F(i,:) - Fbase) ./ Fbase;
end

end

