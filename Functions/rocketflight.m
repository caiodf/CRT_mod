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

%## rocketflight.m

%## Author: S.Box
%## Created: 2008-05-27

function varargout=rocketflight(varargin);
warning off
tic
INTAB1=varargin{1}{1};
INTAB2=varargin{1}{2};
INTAB3=varargin{1}{3};
INTAB4=varargin{2};

landa=varargin{1}{4};
paratab=varargin{1}{5};


RBL=landa(1);%Rocket body length (m)
Ar=landa(2); %Rocket reference area (m^2);
altpd=varargin{3};%parachute deployment altitude (m); 
RL=varargin{4}; %Launch rail length (m);
Ra=varargin{5}; %Launch rail angle(degrees) from vetical 0<Ra<90;
Rbearing=varargin{6}; %Launch rail bearing (degrees) from north 0<Rbearing<360;

label='nofail';

if nargin==7
label=varargin{7};
end

mu=1.8e-5; % kinematic viscosity of air (Ns/m^2);
G=6.6742E-11;% Gravitational constant

Xt=[0;0;0];%Rocket initial position (m);

ttspan=[0 10000];

YA0=[1;0;0];%Reference Yaw axis
PA0=[0;1;0];%Reference Pitch axis
RA0=[0;0;1];%Reference Roll axis

ttspan2=[0 10000];

%INITIAL QUATERNION************************************************
Ra=Ra*pi/180;
Raxb=Rbearing-90;
Rax=bearing_to_vector(Raxb);


Q1=[cos(Ra/2) sin(Ra/2)*Rax(1) sin(Ra/2)*Rax(2) sin(Ra/2)*Rax(3)];

%Runge Kutta integration of rocket equations of motion*************

%Ascent
z0=[Xt(1) Xt(2) Xt(3) Q1(1) Q1(2) Q1(3) Q1(4) 0 0 0 0 0 0];

[tt,z]=ascentcalc(ttspan,z0,YA0,PA0,RA0,INTAB1,INTAB2,INTAB3,INTAB4,Ar,RL,Ra,mu,RBL,G,label);

%Descent
z02=[z(end,1) z(end,2) z(end,3) z(end,8) z(end,9) z(end,10)];

[tt2,z2]=descentcalc(ttspan2,z02,INTAB4,INTAB1,paratab,altpd,G);

sz=size(z);
sz2=size(z2);
zp=zeros((sz(1)+sz2(1)),3);
zp(1:sz(1),1:3)=z(:,1:3);
zp((sz(1)+1):(sz(1)+sz2(1)),1:3)=z2(:,1:3);


Landing(1)=interp1(z2(:,3),z2(:,1),0.2,'linear','extrap');
Landing(2)=interp1(z2(:,3),z2(:,2),0.2,'linear','extrap');

[Aval Aht]=max(z(:,3));
apogee(1:3)=z(Aht,1:3);
apogeetime=tt(Aht);

%%Calculate Stats%%%

%%%%%%%%%%%%%%%%%%%%

%%Output Display%%%%
disp(sprintf('\n\nCambridge Rocketry Simulator\n'))
disp(sprintf('Simulation complete at: %s',datestr(now)))
toc
disp(sprintf('\nApogee data:'))
disp(sprintf('Apogee reached %d seconds after launch',apogeetime))
if (apogee(1)<0)
  Easting='West';
else
  Easting='East';
end

if (apogee(2)<0)
  Northing='South';
else
  Northing='North';
end
disp(sprintf(['Apogee location is %dm ',Easting,' and %dm ',Northing,' of launch location'],abs(apogee(1)),abs(apogee(2))))
disp(sprintf('Apogee altitude is %dm\n',apogee(3)))
disp(sprintf('Landing data:'))
disp(sprintf('Landing occurred %d seconds after launch',(tt(end)+tt2(end))))
if (Landing(1)<0)
  Easting='West';
else
  Easting='East';
end

if (Landing(2)<0)
  Northing='South';
else
  Northing='North';
end
disp(sprintf(['Landing location is %dm ',Easting,' and %dm ',Northing,' of launch location\n'],abs(Landing(1)),abs(Landing(2))))
%%%%%%%%%%%%%%%%%%%%

figure
plot3(zp(:,1),zp(:,2),zp(:,3),'Linewidth',2);
axis equal
set(gca,'xlim',[(min(zp(:,1))-100) (max(zp(:,1))+100)])
set(gca,'ylim',[(min(zp(:,2))-100) (max(zp(:,2))+100)])
set(gca,'zlim',[0 (max(zp(:,3))+100)])
xlabel('East (m)')
ylabel('North (m)')
zlabel('Altitude (m)')
title('Flight Path')
set(gca,'XGrid','on') 
set(gca,'YGrid','on') 
set(gca,'ZGrid','on') 

% open elsworthmapbig.fig
% hold on
% plot(0,0,'ko',Landing(1),Landing(2),'bx','markersize',18,'linewidth',3);
Asc=[tt,z];
Des=[tt2,z2];
%%Comand Line Output %%%%%%%


varargout={Asc,Des,Landing,apogee};
