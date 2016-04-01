function imname = dir_bo(datadir)
% written by Liefeng Bo in University of Washington on 01/04/2011

% remove rootdir
imname = dir(datadir);
imname(1:2) = [];

if ~isempty(imname)
    if strcmp(imname(1).name,'.DS_Store')
        imname(1)=[];
    end
end
