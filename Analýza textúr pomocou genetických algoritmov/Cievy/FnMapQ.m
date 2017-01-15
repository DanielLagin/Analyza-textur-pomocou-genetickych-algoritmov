function [MapQ,VsBaru] = FnMapQ(IG,Vs,baris,kolom,w,T)
[VL,VLmax,VLmaxIndex] = FnVL(IG,Vs,baris,kolom,w);

penambah_teta_x=[1 -1 0 0 1 -1 1 -1];
penambah_teta_y=[0 0 1 -1 1 -1 -1 1];

maxVLIndex=find(VLmax>T);

[Vsx,Vsy] = Index2XY(Vs,baris);

VcxTerpilih1=Vsx(maxVLIndex)';
VcyTerpilih1=Vsy(maxVLIndex)';

VcxTerpilih1OutIndex=find(VcxTerpilih1<1 | VcxTerpilih1>baris);
VcyTerpilih1OutIndex=find(VcyTerpilih1<1 | VcyTerpilih1>kolom);

VcxyTerpilih1OutIndex=union(VcxTerpilih1OutIndex,VcyTerpilih1OutIndex);

VcxTerpilih1(VcxyTerpilih1OutIndex)=[];
VcyTerpilih1(VcxyTerpilih1OutIndex)=[];

MapQ = XY2Index(VcxTerpilih1,VcyTerpilih1,baris);

VcxTerpilih2=Vsx(maxVLIndex)'+penambah_teta_x(VLmaxIndex(maxVLIndex))';
VcyTerpilih2=Vsy(maxVLIndex)'+penambah_teta_y(VLmaxIndex(maxVLIndex))';

VcxTerpilih2OutIndex=find(VcxTerpilih2<1 | VcxTerpilih2>baris);
VcyTerpilih2OutIndex=find(VcyTerpilih2<1 | VcyTerpilih2>kolom);

VcxyTerpilih2OutIndex=union(VcxTerpilih2OutIndex,VcyTerpilih2OutIndex);

VcxTerpilih2(VcxyTerpilih2OutIndex)=[];
VcyTerpilih2(VcxyTerpilih2OutIndex)=[];

VsBaru = XY2Index(VcxTerpilih2,VcyTerpilih2,baris);