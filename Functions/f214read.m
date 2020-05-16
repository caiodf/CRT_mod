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

%## f214read.m

%## Author: S.Box
%## Created: 2008-05-27


%f214 data read and convert
%Simon Box
%3 May 2006

function [intab]=f214read(varargin);

F214=varargin{1};
F214=flipud(F214);
if nargin==3;
    wmag=varargin{2};
    wdir=varargin{3};
else
    wmag=1;
    wdir=0;
end
    

F214si(:,1)=F214(:,1)*304.88;
F214si(:,2)=F214(:,2);
F214si(:,3)=F214(:,3)*0.447;
F214si(:,4)=F214(:,4)+273.15;



F214si(:,3)=F214si(:,3)*wmag;
F214si(:,2)=F214si(:,2)+wdir;

sf2=size(F214);
for i=1:sf2(1);
    Wd=bearing_to_vector(F214si(i,2));
    W=Wd*F214si(i,3);
    intab(i,2)=W(1);
    intab(i,3)=W(2);
end
    
    
intab(:,1)=F214si(:,1);
intab(:,4)=zeros(sf2(1),1);
intab(:,5)=(-0.0001*intab(:,1))+1.2208;
intab(:,6)=F214si(:,4);


        

