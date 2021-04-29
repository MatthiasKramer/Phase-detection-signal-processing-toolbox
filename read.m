function [S1r,S2r,y] = read(j)
    % READ Walks through the directory, in search of *.dat files, and returns the voltage raw signals and probe position.
    %
    %   This function reads the raw signals (binary files), ignores headers and builds two vectors (S1r, S2r) with the raw
    %   signals. The function also searches for the probe position and returns it as a scalar (y).
    %
    %   Please, note that if your data files do not use binarisation, the fread function should be used differently.
    %   Please, also note that if data acquisition files do not include probe position, this should be commented out and bypassed to avoid errors.
    
    nChannels=2; % number of channels 
    files = dir('*.dat');  
    [fileID,~]=fopen(files(j).name);
    A=fread(fileID,'int16','l')*5/32767; % specific to used binarisation.

    S1r=A(5:nChannels:size(A)); % r: raw signal
    S2r=A(6:nChannels:size(A));
 
    txt = textscan(files(j).name,'%f %f %f','Delimiter','_'); % probe position
    y = txt{2}+(txt{3}/100);
    
end
