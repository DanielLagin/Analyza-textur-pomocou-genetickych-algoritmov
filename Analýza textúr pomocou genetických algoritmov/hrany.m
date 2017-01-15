%HRANOVÁ REPREZENTÁCIA
%Vstup reprezentuje vstupný obrázok, výsek veµkosti 64x64
%Segmentácia hrán v obraze, sèítanie pixelov v hranách

function [ output ] = hrany( image, sigma, minimal, classifier )
I = imread(image); %naèítanie obrázku
dim = ndims(I);

if(dim == 3)
    I = rgb2gray(I);
end

BW = edge(I,'log',0.0007,sigma); %hranová reprezentácia LOG
BW = bwareaopen(BW,minimal); %odstránenie hrán men¹ích ako minimal

nWhite = sum(BW(:)); %poèet pixelov hrán
disp(['nWhite equals: ',num2str(nWhite)]);

imshow(BW);

if nWhite > classifier %premenná urèuje, èi je analyzovaný výsek textúra alebo nie
    output = 1; %obsahuje textúru
else
    output = 0; %neobsahuje textúru   
end
disp(output);
end