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

%## Barrowman_calc.m

%## Author: S.Box
%## Created: 2008-05-27

function [Cna,Xcp]=Barrowman_calc(varargin);

% This Function uses the "Barrowman method" to calculate the normal force 
% coeficient and location of the centre of pressure for a rocket. The
% function works by calculating these two parameters for each rocket 
% component individualy. Input data can be given for any number or 
% combination or rocket components.
% 
% Input arguments must be a cell array with the first cell containing a
% string that identifies the type of component. Permissable strings are:
% 'nose', 'cone_trans', 'finset'.
% 
% in the case of the nosecone ('nose') the second cell is also a string which 
% identifies the shape of the nose. Permissable strings are: 'conical', 
% 'ogive', 'parabolic'.
% 
% The last cell contains a vector with the relevant dimensions of the 
% component.
% 
% Nosecone example, vector has 2 arg
% 
% {'nose'}{'conical'}{[length,position (dist from upstream point to nose 
% tip)(usually 0!) ]}
% 
% Conical transition example, vector has 5 args
% 
% {'cone_trans'}{[ref diameter, upstream diameter, downstream diameter, 
% length, position (dist from upstream point to nose tip)]}
% 
% Finset example, vector has 7 args
% 
% {'finset'}{[number of fins, finset tube diameter,reference diameter, fin root lenth, fin tip 
% lenght, fin sweep length, fin span length, position 
% (dist from upstream point to nose tip)]}


for i=1:nargin;
    
    label=varargin{i}{1};
    
    switch label;
        
        case 'nose';
            
            Aero(i,1)=2;
            nlabel=varargin{i}{2};
            L=varargin{i}{3}(1);
            X=varargin{i}{3}(2);
            switch nlabel;
                case 'conical';
                    Aero(i,2)=X+2*L/3;
                case 'ogive';
                    Aero(i,2)=X+0.466*L;
                case 'parabolic';
                    Aero(i,2)=X+L/2;
                case 'von karman'
                    Aero(i,2)=X+L/2;
            end;

        case 'cone_trans';
            dr=varargin{i}{2}(1);
            du=varargin{i}{2}(2);
            dd=varargin{i}{2}(3);
            L=varargin{i}{2}(4);
            X=varargin{i}{2}(5);
            
            Aero(i,1)=2*((dd/dr)^2-(du/dr)^2);
            
            Aero(i,2)=X+(L/3)*(1+((1-(du/dd))/(1-(du/dd)^2)));
            
        case 'finset';
            n=varargin{i}{2}(1);
            d=varargin{i}{2}(2);
            dr=varargin{i}{2}(3);
            a=varargin{i}{2}(4);
            b=varargin{i}{2}(5);
            m=varargin{i}{2}(6);
            s=varargin{i}{2}(7);
            X=varargin{i}{2}(8);
            
            l=sqrt((m+(0.5*b)-(0.5*a))^2+s^2);
            
            r=d/2;
            
            k=1+(r/(s+r));
            
            Aero(i,1)=(k*4*n*(s/dr)^2)/(1+sqrt(1+(2*l/(a+b))^2));
            
            Aero(i,2)=X+(m*(a+2*b))/(3*(a+b))+(1/6)*(a+b-a*b/(a+b));
    end
end

Aero(:,3)=Aero(:,1).*Aero(:,2);
%disp(Aero);
Cna=sum(Aero(:,1));
Xcp=sum(Aero(:,3))/Cna;