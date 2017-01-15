function [VL,VLmax,VLmaxIndex] = FnVL(IG,Vs,baris,kolom,w)

VL=ones(length(Vs),8);

bac1 = Fnbac122cand(IG,Vs,baris,kolom,1,w);
bac2 = Fnbac122cand(IG,Vs,baris,kolom,1,-w);
cand = 2*Fnbac122cand(IG,Vs,baris,kolom,1,0);

bac1 = Fnbac122cand(IG,Vs,baris,kolom,-1,w);
bac2 = Fnbac122cand(IG,Vs,baris,kolom,-1,-w);
cand = 2*Fnbac122cand(IG,Vs,baris,kolom,-1,0);
VL(:,2)=bac1+bac2-cand;

bac1 = Fnbac122cand(IG,Vs,baris,kolom,w,1);
bac2 = Fnbac122cand(IG,Vs,baris,kolom,-w,1);
cand = 2*Fnbac122cand(IG,Vs,baris,kolom,0,1);
VL(:,3)=bac1+bac2-cand;

bac1 = Fnbac122cand(IG,Vs,baris,kolom,w,-1);
bac2 = Fnbac122cand(IG,Vs,baris,kolom,-w,-1);
cand = 2*Fnbac122cand(IG,Vs,baris,kolom,0,-1);
VL(:,4)=bac1+bac2-cand;

bac1 = Fnbac122cand(IG,Vs,baris,kolom,(1+w),(1-w));
bac2 = Fnbac122cand(IG,Vs,baris,kolom,(1-w),(1+w));
cand = 2*Fnbac122cand(IG,Vs,baris,kolom,1,1);
VL(:,5)=bac1+bac2-cand;

bac1 = Fnbac122cand(IG,Vs,baris,kolom,(w-1),-(1+w));
bac2 = Fnbac122cand(IG,Vs,baris,kolom,-(1+w),(w-1));
cand = 2*Fnbac122cand(IG,Vs,baris,kolom,-1,-1);
VL(:,6)=bac1+bac2-cand;

bac1 = Fnbac122cand(IG,Vs,baris,kolom,(1+w),(w-1));
bac2 = Fnbac122cand(IG,Vs,baris,kolom,(1-w),-(1+w));
cand = 2*Fnbac122cand(IG,Vs,baris,kolom,1,-1);
VL(:,7)=bac1+bac2-cand;

bac1 = Fnbac122cand(IG,Vs,baris,kolom,(w-1),(w+1));
bac2 = Fnbac122cand(IG,Vs,baris,kolom,-(1+w),(1-w));
cand = 2*Fnbac122cand(IG,Vs,baris,kolom,-1,1);
VL(:,8)=bac1+bac2-cand;

[VLmax,VLmaxIndex]=max(VL');
