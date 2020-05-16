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

%## axi_com.m

%## Author: S.Box
%## Created: 2008-05-27

function Xcm=axi_com(varargin);

% This function calculates the distance of the centre of mass of an 
% axisymetric object (like a rocket) from some reference point (like the tip 
% of a rocket nose). The inputs are any number of two element vectors 
% representing point masses. the structure of the vectors are [M,X], where
% M is the mass and X is the distance of the point mass from the reference 
% point.

for i=1:nargin;
    M(i)=varargin{i}(1);
    X(i)=varargin{i}(2);
end

MX=M.*X;

Xcm=sum(MX)/sum(M);