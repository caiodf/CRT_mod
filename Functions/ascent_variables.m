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

%## ascent_variables.m

%## Author: S.Box
%## Created: 2008-05-27

%Rocket Flight Model, Variable calculator
%Simon Box
%Dec 2006

%This function is a modified version of the funtion ascentcalc, where 
%ascentcalc can be called by a numerical integration function like ODE, 
%this function is called by "flight_variables" and is uses the output data
%from a numerical simulation calculate all the rocket variables at a
%specific point in the rockets flight

function [col_headers,data_tab]=ascent_variables(varargin);

Asc=varargin{1};%Simulation output data array
YA0=varargin{2};%reference yaw axis vector
PA0=varargin{3};%reference pitch axis vector
RA0=varargin{4};%reference roll axis vector
INTAB1=varargin{5};%%Time dependant data
INTAB2=varargin{6};%Drag data
INTAB3=varargin{7};%Normal force data
INTAB4=varargin{8};%Altitude dependant data
Ar=varargin{9};%Rocket cross sectional area (m^3)
RL=varargin{10};%launch rail length (m)
Ra=varargin{11};%launch rail declination(degrees);
mu=varargin{12};%kinematic viscosity
RBL=varargin{13};%Rocket body length(m)
G=varargin{14};%Universal gravity constant
if nargin==14;
    ig_delay=0;%ignition delay.
elseif nargin==15;
    ig_delay=varargin{15};
end

tt=Asc(:,1);
z=Asc(:,2:end);
%Constants****************************************************************
gamma=1.4; %Ratio if specific heats for air
R=287; %gas constant (cp-cv) for air
cll=0.4; %Lower limit of compressible flow (Mach #)
pgl=0.8; %Lower limit of prandtl glauert singularity (Mach #)
pgu=1.2; %Upper limit of prandtl glauert singularity (Mach #)

% asc = Asc;
% i1 = INTAB1;
% i2 = INTAB2;
% i3 = INTAB3;
% i4 = INTAB4;
% save('teste.mat','asc','i1','i2','i3','i4')


for i=1:length(tt);

    %Unpack z*****************************************************************
    xn=z(i,1);%postion vector
    yn=z(i,2);%"
    zn=z(i,3);%"
    s=z(i,4);%quaternion scalar
    vx=z(i,5);%quaternion vector
    vy=z(i,6);%"
    vz=z(i,7);%"
    Px=z(i,8);%Translational momentum vector
    Py=z(i,9);%"
    Pz=z(i,10);%"
    Ltheta=z(i,11);%Rotational momentum vector
    Lphi=z(i,12);%"
    Lpsi=z(i,13);%"

    %gravity******************************************************************
    %g=G*5.9742E24/(6378100+zn)^2;
    g=9.81;

    %EXTRACT DATA FROM INPUT TABLES 1 and 4***********************************

    %INTAB1*******************************************************************
    t=INTAB1(:,1); %Get time data from input table
    t=t+ig_delay;
    
    if tt(i)<=t(1);
        Ti=INTAB1(1,2);
        Mi=INTAB1(1,3);
        Ixxi=INTAB1(1,4);
        Iyyi=INTAB1(1,5);
        Izzi=INTAB1(1,6);
        Ixyi=INTAB1(1,7);
        Ixzi=INTAB1(1,8);
        Iyzi=INTAB1(1,9);
        Xcmi=INTAB1(1,10);
        Cda1=INTAB1(1,11);

    elseif tt(i)<t(end) && tt(i)>t(1);
        Ti=interp1(t,INTAB1(:,2),tt(i));%Thrust-time data
        Mi=interp1(t,INTAB1(:,3),tt(i));%Mass-time data
        Ixxi=interp1(t,INTAB1(:,4),tt(i));%Moments of inertia-time data
        Iyyi=interp1(t,INTAB1(:,5),tt(i));%"
        Izzi=interp1(t,INTAB1(:,6),tt(i));%"
        Ixyi=interp1(t,INTAB1(:,7),tt(i));%Products of inertia-time data
        Ixzi=interp1(t,INTAB1(:,8),tt(i));%"
        Iyzi=interp1(t,INTAB1(:,9),tt(i));%"
        Xcmi=interp1(t,INTAB1(:,10),tt(i));%C.O.M.-time data
        Cda1=interp1(t,INTAB1(:,11),tt(i));%Thrust damping moment coefficient
    else
        Ti=INTAB1(end,2);
        Mi=INTAB1(end,3);
        Ixxi=INTAB1(end,4);
        Iyyi=INTAB1(end,5);
        Izzi=INTAB1(end,6);
        Ixyi=INTAB1(end,7);
        Ixzi=INTAB1(end,8);
        Iyzi=INTAB1(end,9);
        Xcmi=INTAB1(end,10);
        Cda1=INTAB1(end,11);
    end


    %INTAB4*******************************************************************

    ztb=INTAB4(:,1); %Get altitude data from input table


    if zn<ztb(end) && zn>=ztb(1);
        Wxi=interp1(ztb,INTAB4(:,2),zn);%Wind velocity vector
        Wyi=interp1(ztb,INTAB4(:,3),zn);%"
        Wzi=interp1(ztb,INTAB4(:,4),zn);%"
        rho=interp1(ztb,INTAB4(:,5),zn);%Atmospheric density
        temp=interp1(ztb,INTAB4(:,6),zn);%Atmospheric Temperature
    else
        %error('Altitude data exceeded');
        Wxi=INTAB4(end,2);
        Wyi=INTAB4(end,3);
        Wzi=INTAB4(end,4);

        temp=(-131.21+(0.00299*zn))+273.15;
        Pressure=0.002488*(temp/216.6)^-11.388;
        rho=Pressure/287*temp;

        %warning('outside table 4');
    end

    %Calculate angle of attack (alpha)****************************************
    Pt=[Px;Py;Pz]; %Rocket momentum vector

    if vectormag([xn;yn;zn])<=RL;
        Wt=[0;0;0];
    else
        Wt=[Wxi;Wyi;Wzi]; %Wind vector
    end

    Ut=Pt./Mi; %Rocket earth relative velocity vector
    Vt=Ut+Wt; %Rocket atmosphere relative velocity vector

    Xt=[xn;yn;zn];%Position vector
    qt=[s vx vy vz];%Quaternion
    Lt=[Ltheta;Lphi;Lpsi];%Rotational momentum vector

    Ibody=[Ixxi Ixyi Ixzi;Ixyi Iyyi Iyzi;Ixzi Iyzi Izzi];%Inertia tensor

    qt=vectornorm(qt);%Normalise quaternion

    s=qt(1);
    vx=qt(2);
    vy=qt(3);
    vz=qt(4);

    vt=[vx;vy;vz];%Quaternion vector part only

    Rt=quaternion_to_matrix(qt);%Transform quaternion to rotation matrix

    YA=Rt*YA0;%Yaw axis vector
    PA=Rt*PA0;%Pitch axis vector
    RA=Rt*RA0;%Roll axis vector

    Utmag=vectormag(Ut);%Rocket earth reference velocity
    Vtmag=vectormag(Vt);%Rocket atmosphere reference velocity


    RAnorm=vectornorm(RA);%Are these necessary?
    Vtnorm=vectornorm(Vt);%"

    if Vtmag==0;
        alpha=0;
    else
        dprod=dot(Vtnorm,RAnorm);
        if dprod>1;
            dprod=1;
        end
        alpha=acos(dprod);
    end


    Re=rho*Utmag*RBL/mu;%Calculate Reynolds number

    %EXTRACT DATA FROM INPUT TABLES 2 and 3***********************************
    %INTAB2*******************************************************************
    an=INTAB2(2:end,1);%Get CD from table
    Ren=INTAB2(1,2:end);
    Cddat=INTAB2(2:end,2:end);

    if alpha<an(end) && alpha>=0 && Re>=Ren(1) && Re<Ren(end);
        Cd=interp2(Ren,an,Cddat,Re,alpha);
    elseif alpha<an(end) && alpha>=0 && Re>=Ren(end);
        Cd=interp1(an,Cddat(:,end),alpha);
    elseif alpha<an(end) && alpha>=0 && Re>=0 && Re<Ren(1);
        Cd=interp1(an,Cddat(:,end),alpha);
    elseif alpha>an(end);
        Cd=1.0;
    else
        %error('CD out of range');
        Cd=0.5;%Hack !!Change to error message!!
        warning('outside table 2')
    end

    %INTAB3*******************************************************************

    Cn=INTAB3(1);
    Cp=INTAB3(2);

    %Prandtl-Glauert Compressibility correction**************************

    c=sqrt(gamma*R*temp);
    Ma=Vtmag/c;

    if Ma<cll;
        Cd=Cd;
        Cn=Cn;
    elseif Ma>=cll && Ma<pgl;
        Cd=Cd/sqrt(1-Ma^2);
        Cn=Cn/sqrt(1-Ma^2);
    elseif Ma>=pgl && Ma<pgu;
        Cd=Cd/sqrt(1-pgl^2);
        Cn=Cn/sqrt(1-pgl^2);
    elseif Ma>=pgu;
        Cd=Cd/sqrt((Ma^2)-1);
        Cn=Cn/sqrt((Ma^2)-1);
    else
        error('Mach error in CD');
    end

    %CP AOA Calculations ***********************************************
    Ibodyinv=inv(Ibody);
    Itinv=Rt*Ibodyinv*Rt';
    Xbar=Cp-Xcmi;%Moment arm
    omegat=Itinv*Lt;%Angular velocity vector

    omegaax=vectornorm(omegat);
    omegaax2=-1*omegaax;

    omega=vectormag(omegat);

    omegacp=omega*Xbar;

    omegacpd=cross(RAnorm,omegaax);
    omegacpd=vectornorm(omegacpd);
    omegacpt=omegacpd*omegacp;

    Vcpt=Vt+omegacpt;

    Vcptmag=vectormag(Vcpt);
    Vcptnorm=vectornorm(Vcpt);


    if Vcptmag==0;
        alphacp=0;
    else
        dprod=dot(Vcptnorm,RAnorm);
        if dprod>1;
            dprod=1;
        end
        alphacp=acos(dprod);
    end

    %Force vector calculations*******************************************
    FA=Cd*0.5*rho*(Vcptmag^2)*Ar*cos(alphacp);%Calculate Axial drag


    FNcp=Cn*0.5*rho*(Vcptmag^2)*Ar*sin(alphacp);


    Tt=Ti*RAnorm;%Thrust Vector
    mg=Mi*g;%Gravity
    FAt=FA*-RAnorm;%Axial drag vector


    momaxcp=cross(RAnorm,Vcptnorm);%axis of pitching motion
    momaxcp=vectornorm(momaxcp);


    %Calculate the normal vorce unit vector**********************************

    FNn=cross(RAnorm,momaxcp);
    FNn=vectornorm(FNn);

    FNt=FNcp*FNn;%Normal force vector



    %Torque vector calculations***********************************************

    Tqf=(FNcp*Xbar)*momaxcp;

    Tqm=(Cda1*omega)*omegaax2;
    Tqt=Tqf+Tqm;



    %Output calculations******************************************************

    %Calculate quaternion derivative
    sdot=(-dot(omegat,vt))*0.5;

    vtdot=((s*omegat)+(cross(omegat,vt)))*0.5;
    vtdot=vectornorm(vtdot);

    vxdot=vtdot(1);
    vydot=vtdot(2);
    vzdot=vtdot(3);


    %Earth relative velocity vector
    xdot=Ut(1);
    ydot=Ut(2);
    zdot=Ut(3);




    if Ti<=mg && zn<0.1;%Z Force vector component
        Fx=0;
        Fy=0;
        Fz=0;
    else
        Fx=Tt(1)+FAt(1)+FNt(1);%X Force vector component
        Fy=Tt(2)+FAt(2)+FNt(2);%Y Force vector component
        Fz=Tt(3)+FAt(3)+FNt(3)-mg;
    end

    if vectormag([xn;yn;zn])<=RL;
        Ttheta=0;
        Tphi=0;
        Tpsi=0;

    else
        Ttheta=Tqt(1);%Torque vector
        Tphi=Tqt(2);
        Tpsi=Tqt(3);
    end
    
     Force=[Fx;Fy;Fz];
    Torque=[Ttheta;Tphi;Tpsi];
    
    xddot=Fx/Mi;%Linear acceleration vector
    yddot=Fy/Mi;
    zddot=Fz/Mi;
    
    angacc=Itinv*Torque;%angular accelleration vector;
   
    %Output line**********************************************************
    %*********************************************************************
    data_tab(i,:)=[tt(i),xn,yn,zn,RA(1),RA(2),RA(3),xdot,ydot,zdot,omegat(1),omegat(2),omegat(3),xddot,yddot,zddot,angacc(1),angacc(2),angacc(3),alpha,alphacp,Xbar,Fx,Fy,Fz,Ttheta,Tphi,Tpsi,Ti,Mi,Xcmi,Ixxi,Iyyi,Izzi,Wxi,Wyi,rho,temp];

end

col_headers={'Time (s)','X position (m)','Y position (m)','Z position (m)','Rocket axis vector X','Rocket axis vector Y','Rocket axis vector Z','Velocity Vx  (m/s)','Velocity Vy  (m/s)','Velocity Vz  (m/s)', 'angular velocity omegaX (rad/s)','angular velocity omegaY (rad/s)','angular velocity omegaZ (rad/s)','Acceleration Ax (m/s2)','Acceleration Ay (m/s2)','Acceleration Az (m/s2)','Angular Acceleration X (rad/s2)','Angular Acceleration Y (rad/s2)','Angular Acceleration Z (rad/s2)','Angle of attack alpha (rad)','alpha at CP (rad)','Moment arm (m)','Force X (N)','Force Y (N)','Force Z (N)','Torque X (Nm)','Torque Y (Nm)','Torque Z (Nm)','Thrust (N)','Mass (kg)', 'C.O.M distance from nose (m)','Ixx (kg m2)','Iyy (kg m2)','Izz (kg m2)', 'Windspeed X (m/s)','Windspeed Y (m/s)','atmospheric density (kg/m3)','atmospheric temperature (K)'};