function [ x ] = TRIM( x, min, max )
%TRIM Summary of this function goes here
%   Detailed explanation goes here
if x > max
    x = max;
else x < min
    x = min;
end

end

