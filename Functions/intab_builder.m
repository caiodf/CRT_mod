%## Copyright (C) 2008 S.Box
%##
%## This program is free software; you can redistribute it and/or modify
%## it under the terms of the GNU General Public License as published by
%## the Free Software Foundation; either version 2 of the License, or
%## (at your option) any later version.
%##
%## This program is distributed in the hope that it will be useful,
%## but WITHOUT ANY WARRANTY; without even the implied warranty of
%## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%## GNU General Public License for more details.
%##
%## You should have received a copy of the GNU General Public License
%## along with this program; if not, write to the Free Software
%## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA

%## intab_builder.m

%## Author: S.Box
%## Created: 2008-05-27


function INTAB=intab_builder(varargin)

nstage=0;

barrow1={};
momin1={};
com1={};

barrow2={};
momin2={};
com2={};

fins1={};
L=[0];
dbase=[0;0];

lt=0;
ln=0;
lb=0;

Mtab=[];
Lbody=[];
paratab=[];

for i=1:nargin
    label=varargin{i}{1};
    
    
    switch label
        case 'nose'
            name=varargin{i}{1};
            shape=varargin{i}{2};
            L=varargin{i}{3};
            d=varargin{i}{4};
            M=varargin{i}{5};
            X=varargin{i}{6};
            
            
            barrow1{end+1}={name,shape,[L X]};
            
            momin1{end+1}={'pm',[M 0 (X+2*L/3)]};
            %position of centroid not correct input to roc_mom
            
            com1{end+1}=[M (X+L/3)];
            
            ln=L;
            
            Mtab(end+1)=M;
            
            
        case 'tube'
            name=varargin{i}{1};
            body=varargin{i}{2};
            L=varargin{i}{3};
            Id=varargin{i}{4};
            Od=varargin{i}{5};
            M=varargin{i}{6};
            X=varargin{i}{7};
            
            
            
            momin1{end+1}={'tube',[M (Id/2) (Od/2) L (X+L/2)]};
            %position of centroid not correct input to roc_mom
            
            com1{end+1}=[M (X+L/2)];
            Mtab(end+1)=M;
            
            
            switch body
                case 'yes'
                    Lbody(end+1)=L;
                    dbase(1:2,end+1)=[X Od];
            end
            
        case 'cylinder'
            name=varargin{i}{1};
            body=varargin{i}{2};
            L=varargin{i}{3};
            d=varargin{i}{4};
            M=varargin{i}{5};
            X=varargin{i}{6};
            
            switch body
                case 'yes'
                    Lbody(end+1)=L;
                    dbase(1:2,end+1)=[X d];
            end
            momin1{end+1}={'cylinder',[M(1) (d/2) L (X+L/2)]};
            
            com1{end+1}=[M (X+L/2)];
            Mtab(end+1)=M;
            
            
        case 'cone_trans'
            name=varargin{i}{1};
            body=varargin{i}{2};
            Ud=varargin{i}{3};
            Dd=varargin{i}{4};
            dr=varargin{i}{5};
            L=varargin{i}{6};
            M=varargin{i}{7};
            X=varargin{i}{8};
            
            
            switch body
                case 'yes'
                    barrow1{end+1}={name,[dr Ud Dd L X]};
                    dbase(1:2,end+1)=[X Dd];
                case 'no'
            end
            
            
            momin1{end+1}={'cylinder',[M ((abs(Ud-Dd))/2) L (X+L/2)]};
            %position of centroid not correct input to roc_mom
            
            com1{end+1}=[M (X+L/2)];
            
            if Ud>Dd
                lt=L;
            end
            
            
            Mtab(end+1)=M;
            
            
            
        case 'pm'
            name=varargin{i}{1};
            M=varargin{i}{2};
            Xr=varargin{i}{3};
            Xl=varargin{i}{4};
            
            
            
            momin1{end+1}={name,[M Xr Xl]};
            
            com1{end+1}=[M Xl];
            Mtab(end+1)=M;
            
            
            
            
        case 'finset'
            name=varargin{i}{1};
            n=varargin{i}{2};
            root_chord=varargin{i}{3};
            tip_chord=varargin{i}{4};
            sweep_length=varargin{i}{5};
            s=varargin{i}{6};
            t=varargin{i}{7};
            M=varargin{i}{8};
            d=varargin{i}{9};
            d_max=varargin{i}{10};
            X=varargin{i}{11};
            
            
            barrow1{end+1}={name,[n d d_max root_chord tip_chord sweep_length s X]};
            
            momin1{end+1}={'pm',[M (d/2+s/2) (X+root_chord/2)]};
            
            com1{end+1}=[M (X+root_chord/2)];
            
            fins1{end+1}={name,[n,root_chord,tip_chord,sweep_length,s,t,d]};
            Mtab(end+1)=M;
            
            
            
        case 'motor'
            name=varargin{i}{1};
            type=varargin{i}{2};
            ttdat=varargin{i}{3};
            L=varargin{i}{4};
            d=varargin{i}{5};
            X=varargin{i}{6};
            
            
            t=ttdat(:,1);
            T=ttdat(:,2);
            M=ttdat(:,3);
            
            
            
            %motor as passenger
            mapmomin1{1}={'cylinder',[M(1) (d/2) L (X+L/2)]};
            
            %motor as thruster
            S1motor={ttdat,L,d,X};
            
        case 'parachute'
            name=varargin{i}{1};
            Cd=varargin{i}{2};
            Ap=varargin{i}{3};
            M=varargin{i}{4};
            X=varargin{i}{5};
            
            momin1{end+1}={'pm',[M 0 X]};
            
            com1{end+1}=[M X];
            
            Mtab(end+1)=M;
            
            paratab(end+1:end+2)=[Cd Ap];
            
            
            
            
    end
end


%Barrowman (INTAB3)
[Cp,Xcp]=Barrowman_calc(barrow1{:});
INTAB3=[Cp,Xcp];


%Drag (INTAB2)
lb=sum(Lbody);
srtdbase=sort(dbase(1,:));
lastcomp=srtdbase(end);
[p,q]=find(dbase(1,:)==lastcomp);
db=dbase(2,q);
srtdbase2=sort(dbase(2,:));
dm=srtdbase2(end);
B1={'body',[ln,lb,lt,dm,db]};

Ltb=ln+lb+lt;
Recrit=5E5;

ir=2;
Rebt(1)=1;
Rebb=Rebt(1);
while Rebb<=100000
    Rebt(ir)=Rebt(ir-1)*10^(1/2);
    Rebb=Rebt(ir);
    ir=ir+1;
end

while Rebb<10000000
    Rebt(ir)=Rebt(ir-1)*10^(1/6);
    Rebb=Rebt(ir);
    ir=ir+1;
end

alphat=[0:0.02:0.16];

sRebt=size(Rebt);
salphat=size(alphat);

for i1=1:sRebt(2)
    for i2=1:salphat(2)
        
        CDtab(i2,i1)=drag_datcom(Ltb,Rebt(i1),Recrit,alphat(i2),B1,fins1{:});
    end
end

INTAB2(1,1)=0;
INTAB2(1,2:sRebt(2)+1)=Rebt;
INTAB2(2:salphat(2)+1,1)=alphat;
INTAB2(2:end,2:end)=CDtab;

landa=[Ltb (dm^2*pi/4)];



%Mass and engine info (Intab1)

Mdr=sum(Mtab);

try
    ttdat=S1motor{1};
    L=S1motor{2};
    d=S1motor{3};
    X=S1motor{4};
    
    t=ttdat(:,1);
    T=ttdat(:,2);
    M=ttdat(:,3);
    
    sttdat=size(ttdat);
    
    for i=1:sttdat(1)
        Motcom=[M(i) (X+L/2)];
        Xcm(i)=axi_com(Motcom,com1{:});
        
        
        smomin1=size(momin1);
        momin1new=momin1;
        for i2=1:smomin1(2)
            
            momin1new{i2}{2}(end)=abs(Xcm(i)-momin1new{i2}{2}(end));
        end
        
        Xdiff=abs(Xcm(i)-(X+L/2));
        motmomin={'cylinder',[M(i) (d/2) L  Xdiff]};
        
        [Ix,Iy,Iz]=Roc_mom_inert(momin1new{:},motmomin);
        Ixyz(i,1:3)=[Ix,Iy,Iz];
    end
    
    Cdar=((M(1)-M(end))/t(end))*(Ltb-Xcm).^2;
    Cdar(end)=0;
    
    INTAB1(:,1)=t;
    INTAB1(:,2)=T;
    INTAB1(:,3)=M+Mdr;
    INTAB1(:,4:6)=Ixyz;
    %INTAB1(:,7:9)=zeros(st,3);
    INTAB1(:,10)=Xcm;
    INTAB1(:,11)=Cdar;
    
catch
    Xcm=axi_com(com1{:});
    
    smomin1=size(momin1);
    momin1new=momin1;
    for i2=1:smomin1(2)
        
        momin1new{i2}{2}(end)=abs(Xcm-momin1new{i2}{2}(end));
    end
    
    
    [Ix,Iy,Iz]=Roc_mom_inert(momin1new{:});
    
    INTAB1=[0 0 Mdr Ix Iy Iz 0 0 0 Xcm 0];
end






INTAB={INTAB1 INTAB2 INTAB3 landa paratab};











