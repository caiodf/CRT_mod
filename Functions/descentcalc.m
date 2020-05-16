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

%## descentcalc.m

%## Author: S.Box
%## Created: 2008-05-27

%Parachute descent model 3 d.o.f
%Simon Box 1 May 2006;
function [tt2,z2]=descentcalc(ttspan2,z02,INTAB4,INTAB1,paratab,altpd,G);

if length(paratab)==4;
    Cdd=paratab(1);
    Ad=paratab(2);
    Cdp=paratab(3);
    Ap=paratab(4);
elseif length(paratab)==2;
    Cdd=paratab(1);
    Ad=paratab(2);
    Cdp=paratab(1);
    Ap=paratab(2);
end

fts=0.1;%first time-step size

options=odeset('Events',@stop2,'InitialStep',fts,'RelTol',1e-6,'AbsTol',1e-6,'MaxStep',1);
[tt2,z2]=ode45(@floatdown3dof,ttspan2,z02,options);

    function zd2=floatdown3dof(tt2,z2,varargin);
        
        %**************************************************************************
        xn=z2(1);%Position vector
        yn=z2(2);%"
        zn=z2(3);%"
        Px=z2(4);%Momentum vector
        Py=z2(5);%"
        Pz=z2(6);%"
        
        %gravity******************************************************************
        g=G*5.9742E24/(6378100+zn)^2;
        %***********************************
        
        ztb=INTAB4(:,1);%get altitude data
        
        
        if zn<ztb(end) && zn>ztb(1);
            Wxi=interp1(ztb,INTAB4(:,2),zn);%Wind velocity vector
            Wyi=interp1(ztb,INTAB4(:,3),zn);%"
            Wzi=interp1(ztb,INTAB4(:,4),zn);%"
            rho=interp1(ztb,INTAB4(:,5),zn);%Atmospheric density
            temp=interp1(ztb,INTAB4(:,6),zn);%Atmospheric temperature
        else
            %warning('Altitude data exceeded');
            Wxi=INTAB4(end,2);
            Wyi=INTAB4(end,3);
            Wzi=INTAB4(end,4);
            
            temp=(-131.21+(0.00299*zn))+273.15;
            Pressure=0.002488*(temp/216.6)^-11.388;
            rho=Pressure/287*temp;
            
        end
        
        Mi=INTAB1(end,3); %Rocket mass
        
        mg=Mi*g;%Gravity
        
        
        Pt=[Px;Py;Pz]; %Rocket momentum vector
        
        Wt=[Wxi;Wyi;Wzi]; %Wind vector
        
        xdot=Px/Mi;
        ydot=Py/Mi;
        zdot=Pz/Mi;
        
        
        Ut=[xdot;ydot;zdot]; %Rocket earth relative velocity vector
        Vt=Ut+Wt; %Rocket atmosphere relative velocity vector
        
        Vtmag=vectormag(Vt);%Velocity magintude
        Vtnorm=vectornorm(Vt);%Velocity unit vector
        
        Fdnorm=-1*Vtnorm;%Drag unit vector
        
        
        if zn>=altpd %Calculate drag
            Fd=Cdd*0.5*rho*Vtmag^2*Ad;
        else
            Fd=Cdp*0.5*rho*Vtmag^2*Ap;
            
        end
        
        Fdt=Fd*Fdnorm;%Drag vector
        
        %ODE Output***************************************************************
        
        
        Fx=Fdt(1);%Force vector
        Fy=Fdt(2);%"
        Fz=Fdt(3)-mg;%"
        
        
        
        zd2=zeros(6,1);
        
        zd2(1)=xdot;
        zd2(2)=ydot;
        zd2(3)=zdot;
        zd2(4)=Fx;
        zd2(5)=Fy;
        zd2(6)=Fz;
    end
end