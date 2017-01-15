function bac1 = Fnbac122cand(IG,Vs,baris,kolom,penambahX,penambahY)

VLcalon=ones(length(Vs),1);

[Vsx,Vsy] = Index2XY(Vs,baris);

bac1x=(VLcalon(:,1).*Vsx')+penambahX;
bac1y=(VLcalon(:,1).*Vsy')+penambahY;

bac1xOutIndex=find(bac1x<1 | bac1x>baris);
bac1yOutIndex=find(bac1y<1 | bac1y>kolom);

bac1xyOutIndex=union(bac1xOutIndex,bac1yOutIndex);

bac1=VLcalon(:,1);

bac1AllIndex = XY2Index(bac1x,bac1y,baris);

bac1xyOutAllIndex=find(bac1AllIndex<1 | bac1AllIndex>(baris*kolom));

bac1AllIndex(bac1xyOutAllIndex)=(bac1AllIndex(bac1xyOutAllIndex)*0)+1;

bac1=double(bac1).*double(IG(bac1AllIndex));
bac1(bac1xyOutIndex)=bac1(bac1xyOutIndex)*0;

bac1NolIndex=find(bac1==0);
bac1Nol=bac1(bac1NolIndex);