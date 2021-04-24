function [S1r,S2r,y] = read(j)

    nChannels=2; %number of channels 
    files = dir('*.dat');  
    [fileID,~]=fopen(files(j).name);
    A=fread(fileID,'int16','l')*5/32767;

    S1r=A(5:nChannels:size(A)); %r: raw signal
    S2r=A(6:nChannels:size(A));
 
    txt = textscan(files(j).name,'%f %f %f','Delimiter','_');
    y = txt{2}+(txt{3}/100);
    
end