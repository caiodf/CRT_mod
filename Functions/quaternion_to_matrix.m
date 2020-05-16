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

%## quaternion_to_matrix.m

%## Author: S.Box
%## Created: 2008-05-27

function [Rt]=quaternion_to_matrix(qt)
s=qt(1);
vx=qt(2);
vy=qt(3);
vz=qt(4);

i1j1=1-2*vy^2-2*vz^2;
i1j2=2*vx*vy-2*s*vz;
i1j3=2*vx*vz+2*s*vy;
i2j1=2*vx*vy+2*s*vz;
i2j2=1-2*vx^2-2*vz^2;
i2j3=2*vy*vz-2*s*vx;
i3j1=2*vx*vz-2*s*vy;
i3j2=2*vy*vz+2*s*vx;
i3j3=1-2*vx^2-2*vy^2;

Rt=[i1j1 i1j2 i1j3;i2j1 i2j2 i2j3;i3j1 i3j2 i3j3];