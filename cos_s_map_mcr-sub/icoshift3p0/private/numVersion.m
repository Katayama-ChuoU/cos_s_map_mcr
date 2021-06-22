function [flag,n] = numVersion(th)
n = str2double(regexp(version,'^\d+?\.\d+','match'));
if (~nargin || isempty(th)), flag = true; else flag = n > th(1); end