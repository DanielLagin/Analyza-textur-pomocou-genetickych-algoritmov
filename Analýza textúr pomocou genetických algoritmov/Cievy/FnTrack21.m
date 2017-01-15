function LineTracking = FnTrack21(IG,Vs,dilateEdge)
tic
[baris,kolom]=size(IG);
[m,n]=size(IG);
Cw=zeros(baris,kolom);
Ts=length(Vs);

%Nastavenie hodnôt pre segmentáciu ciev, urèujú hustotu hrán
T=6;
r=1;
InitScale=3; 
Wstep=2;
FinScale=11;

% Výpis èakania na segmentácia
Counter=ceil(FinScale/InitScale)+1;
CounterLoop=0;
    
hWB = waitbar(0,'Èakajte prosím, prebieha spracovanie vstupov');

for W=InitScale:Wstep:FinScale
    sprintf('W = %d%.3f%%',W)
    w=(W-1)/2;

    [MapQPikselAwal,VsBaru] = FnMapQ(IG,Vs,baris,kolom,w,T);
    Cw(MapQPikselAwal)=Cw(MapQPikselAwal)+1;

    % Trackovanie Pixelov ciev
    [MapQPikselBaru,VsBaru] = FnMapQ(IG,VsBaru,baris,kolom,w,T);
    Cw(MapQPikselBaru)=Cw(MapQPikselBaru)+1;

    CounterLoop=CounterLoop+1;
    waitbar(CounterLoop/Counter);
end

close(hWB);
t = toc/60

% Mapovanie ciev
MapQ1=find(Cw>=fix(FinScale/InitScale));
MapQ2=find(Cw<fix(FinScale/InitScale));
Cw(MapQ1)=Cw(MapQ1)*0+1;
Cw(MapQ2)=Cw(MapQ2)*0;

% Vyhµadávanie èiar v obraze
LineTracking=Cw;
Bw=Cw;
BwTanpaEdge=zeros(m,n);
edgeRetinaPth = find(dilateEdge>0);
edgeRetinaHtm = find(dilateEdge<1);
BwTanpaEdge(edgeRetinaPth) = Bw(edgeRetinaPth)*0;
BwTanpaEdge(edgeRetinaHtm) = Bw(edgeRetinaHtm)*0+Bw(edgeRetinaHtm);

%Mediánové filtre
Bw2 = medfilt2(BwTanpaEdge);

%Filtrovanie
%pre uhol = 0
se = strel('line',3, 0);
hslOp1 = imopen(Bw2, se);
%pre uhol = 30
se = strel('line',3, 30);
hslOp2 = imopen(Bw2, se);
%pre uhol = 60
se = strel('line',3, 60);
hslOp3 = imopen(Bw2, se);
%pre uhol = 120
se = strel('line',3, 120);
hslOp4 = imopen(Bw2, se);
%pre uhol = 180
se = strel('line',3, 150);
hslOp5 = imopen(Bw2, se);

[brsHslOp,KolHslOp] = size(hslOp1);
hslOp = hslOp1+hslOp2+hslOp3+hslOp4+hslOp5;
se2 = strel('disk',2);
marker = imerode(hslOp, se2);
mask = hslOp;
Bw3 = imreconstruct(marker, mask);