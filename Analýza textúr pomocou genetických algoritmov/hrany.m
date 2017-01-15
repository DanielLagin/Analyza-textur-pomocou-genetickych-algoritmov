%HRANOV� REPREZENT�CIA
%Vstup reprezentuje vstupn� obr�zok, v�sek ve�kosti 64x64
%Segment�cia hr�n v obraze, s��tanie pixelov v hran�ch

function [ output ] = hrany( image, sigma, minimal, classifier )
I = imread(image); %na��tanie obr�zku
dim = ndims(I);

if(dim == 3)
    I = rgb2gray(I);
end

BW = edge(I,'log',0.0007,sigma); %hranov� reprezent�cia LOG
BW = bwareaopen(BW,minimal); %odstr�nenie hr�n men��ch ako minimal

nWhite = sum(BW(:)); %po�et pixelov hr�n
disp(['nWhite equals: ',num2str(nWhite)]);

imshow(BW);

if nWhite > classifier %premenn� ur�uje, �i je analyzovan� v�sek text�ra alebo nie
    output = 1; %obsahuje text�ru
else
    output = 0; %neobsahuje text�ru   
end
disp(output);
end