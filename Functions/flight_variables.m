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

%## flight_variables.m

%## Author: S.Box
%## Created: 2008-05-27

%flight variables calculator
%Simon Box
%Dec 2006

%This function builds a table containing all the important variables in a
%rocket simulation against time. The function can be run after any of the
%rocket flight simulations have been run and it builds the table using the
%output data from the rocket simulations in the workspace.
%The inputs for the function are as follows:
%(INPUT,INPUT4,altpd,RL,Ra,Rbearing,(igdelay),tt,z)
%Where
%"INTAB" is the input rocket data, "INTAB4" is the atmospheric data input
%table ,"altpd" is the altitude of main parachute deployment for a dual
%deploy system. If the rocket is not dual deploy then a value must still be
%specified the value won't affect the output of the model but 0 is a good
%choice. "RL" is the length of the rocket lauch rail in (m),"Ra" is the
%angle of the launch rail from the vertical in degrees, "Rbearing" is the
%bearing the rail is pointion from North (degrees), "igdelay" is an
%optional variable if the input flight is the second stage of a two stage
%rocket this variable is the ignition delay from sepatation in seconds,"tt"
%is the array containing time values from the flight simulation output, "z"
%is the corresponding simulation output data table containing position and
%momentum data.
%The outputs are are a cell array containing lables for the columns of the
%data table, and the data table itself.

function varargout=flight_variables(varargin)


mu=1.8e-5; % kinematic viscosity of air (Ns/m^2);
G=6.6742E-11;% Gravitational constant

YA0=[1;0;0];%Reference Yaw axis
PA0=[0;1;0];%Reference Pitch axis
RA0=[0;0;1];%Reference Roll axis

filename=varargin{1};
Asc=varargin{2};
INTAB1=varargin{3}{1};%Time dependant data
INTAB2=varargin{3}{2};%Drag data
INTAB3=varargin{3}{3};%Normal force data
INTAB4=varargin{4};%Altitude dependant data

landa=varargin{3}{4};%rocket length and area
paratab=varargin{3}{5};%Parachute data


RBL=landa(1);%Rocket body length (m)
Ar=landa(2); %Rocket reference area (m^2);
altpd=varargin{4};%parachute deployment altitude (m);
RL=varargin{5}; %Launch rail length (m);
Ra=varargin{6}; %Launch rail angle(degrees) from vetical 0<Ra<90;
Rbearing=varargin{7}; %Launch rail bearing (degrees) from north 0<Rbearing<360;
if nargin==9
    igdelay=varargin{8};% Ignition delay (s)
else
    igdelay=0;
end

[RDT_col_headers,rocket_data_tab]=ascent_variables(Asc,YA0,PA0,RA0,INTAB1,INTAB2,INTAB3,INTAB4,Ar,RL,Ra,mu,RBL,G,igdelay);

varargout={RDT_col_headers,rocket_data_tab};

csvmaker(RDT_col_headers,rocket_data_tab,filename);


