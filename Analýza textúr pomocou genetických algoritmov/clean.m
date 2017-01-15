fclose all;
close all;
clear all;
clc;

%Nastavenia pracovneho prostredia
workspace;
fontSize = 16;

%Zmen priecinok na aktualny
if(~isdeployed)
	cd(fileparts(which(mfilename)));
end