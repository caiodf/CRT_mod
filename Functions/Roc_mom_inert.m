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

%## Roc_mom_inert.m

%## Author: S.Box
%## Created: 2008-05-27

function [Ix,Iy,Iz]=Roc_mom_inert(varargin);

%Simon Box
%24 July 2006

%     Simple moments of inertia calculator for a Rocket. The composite moment 
% of inertia is calculated from an unlimited number of smaller component masses
% that can be classified s either a "cylinder", a "tube" or a point mass 
% ("pm").
%     Input arguments must be a cell array the first cell of which contains a 
% string identifying the array as either "cylinder" "tube" or "pm", the 
% second cell is a vector that contains the relevant masses and dimensions 
% required to calculate the moments of inertia.
% 
% Cylinder
%     The cylinder input is a four element vecto containing: [Mass,Radius,
% Length,Distance from centre of mass (Xcm)]
%
% e.g. {'cylinder'}{[M,R,L,X]}
% 
% Tube
%     The tube input is a five element vector: [Mass,Rad(inner),Rad(outer),
% Length,Xcm]
%
% e.g. {'tube'}{[M,Ri,Ro,L,X]}
% 
% Point Mass
%     The point mass input is a three vector array: [Mass,Xcm(long),
% Xcm(rad)]
%
% e.g. {'pm'}{[M,Xr,Xl]}
% 
%     The assumption is that the axis of tubes and cylinders are coincedent 
% with the rocket axis. Point masses can be anywhere but for calculation 
% longitudinal moments of inertia they will be assumed to lie on the rocket 
% axis, this assumtion is valid assuming the rocket is long and thin, and the 
% point mass is not very close to the centre of mass.
% 
%     The output is three components of moments of inertia for cartesian axis
% whose z axis is alighned with the axis of the rocket.



for i=1:nargin;
    
    label=varargin{i}{1};
    
    switch label;
        case 'cylinder';
            M=varargin{i}{2}(1);
            R=varargin{i}{2}(2);
            L=varargin{i}{2}(3);
            X=varargin{i}{2}(4);
            
            I(i,1)=((1/12)*M*(3*R^2+L^2))+M*X^2;
            I(i,2)=I(i,1);
            I(i,3)=(1/2)*M*R^2;
            
        case 'tube';
            M=varargin{i}{2}(1);
            Ri=varargin{i}{2}(2);
            Ro=varargin{i}{2}(3);
            L=varargin{i}{2}(4);
            X=varargin{i}{2}(5);
            
            I(i,1)=((1/12)*M*(3*(Ri^2+Ro^2)+L^2))+M*X^2;
            I(i,2)=I(i,1);
            I(i,3)=(1/2)*M*(Ri^2+Ro^2);
            
        case 'pm';
            M=varargin{i}{2}(1);
            Xr=varargin{i}{2}(2);
            Xl=varargin{i}{2}(3);
            
            I(i,1)=M*Xl^2;
            I(i,2)=I(i,1);
            I(i,3)=M*Xr^2;
    end
end

Ix=sum(I(:,1));
Iy=sum(I(:,2));
Iz=sum(I(:,3));
