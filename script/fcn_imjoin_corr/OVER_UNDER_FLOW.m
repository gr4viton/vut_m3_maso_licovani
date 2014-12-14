function [ off_under, off_over ] = OVER_UNDER_FLOW( x, xmin, xmax )
%TRIM Summary of this function goes here
%   Detailed explanation goes here
off_under = 0;
off_over = 0;
if x < xmin
    off_under = abs(min(y_int));
end
if x > xmax
    off_over = max(y_int) - i2h;
end

end

