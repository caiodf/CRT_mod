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

%## drag_datcom.m

%## Author: S.Box
%## Created: 2008-05-27

function Cd=drag_datcom(varargin);

% This function calculated the drag on a rocket using the US D.A.T.C.O.M.
% method. the input arguments must take the following form:
% Cd=drag_datcom(Ltb,Re,Recrit,alpha,B1,F1,F2......)
%
% Ltb is the total length of the rocket body, not including fins. Re is the
% Reynolds number of the rocket using Ltb as the charachteristic dimension,
% Recrit is the critical Reynolds number (recommend 10^5),
% alpha is the angle of attack of the rocket. B1, F1 etc are any number of
% cell arrays containing geometrical information about the rocket.
%
% The first cell of a cell array must be a string which itentifies the type
% of geometry data contained. Permissable strings are 'body' and 'finset'
%
% In the case of 'body' the second cell is a vector with the structure:
% [ln,lb,lt,dm,db], where ln is the nose length, lb is the body tube length
% lt is the boattail length (if no boattail use 0) dm is the maximum body diameter
% and db is the base diameter.
%
% In the case of 'finset' the second cell is a vector with the structure:
% [n,a,b,m,s,t,d], where n is the number of fins, a is the root lenght, b is
% the tip length, m is the sweep length, s is the span of a single fin, t
% is the d is fin thickness, d is the diameter of the body tube at the finset.

Ltb=varargin{1};
Re=varargin{2};
Recrit=varargin{3};
alpha=varargin{4};

for i=5:nargin;
    label=varargin{i}{1};

    switch label;
        case 'body';
            ln=varargin{i}{2}(1);
            lb=varargin{i}{2}(2);
            lt=varargin{i}{2}(3);
            dm=varargin{i}{2}(4);
            db=varargin{i}{2}(5);

            lr=ln+lb+lt;

            mfac=lr/Ltb;

            Ren=Re*mfac;

            B=Recrit*(0.074/Ren^(1/5)-1.328/sqrt(Ren));

            if Ren<=Recrit;
                Cfbod=1.328/sqrt(Ren);
            elseif Ren>Recrit;
                Cfbod=0.074/Ren^(1/5)-B/Ren;
            end

            Cdbod=(1+60/(lr/dm)^3+0.0025*lb/dm)*(2.7*ln/dm+4*lb/dm+2*(1-(db/dm))*lt/dm)*Cfbod;

            Cdbase=0.029*(db/dm)^3/sqrt(Cdbod);

            CD(i,1)=Cdbod+Cdbase;
            
            %drag due to angle of attack alpha
             SF=lr/db; %body slenderness factor
             
             deltaktab=[4 6 8 10 12 14 16 18 20;0.78 0.86 0.92 0.94 0.96 0.97 0.975 0.98 0.982];
             deltak=interp1(deltaktab(1,:),deltaktab(2,:),SF,'linear','extrap');
             if deltak>1;
                 deltak=1;
             end
             %deltak=-7e-6*SF^4+0.0004*SF^3-0.0107*SF^2+0.1183*SF+0.4535
             
             etatab=[4 6 8 10 12 14 16 18 20 22 24;0.6 0.63 0.66 0.68 0.71 0.725 0.74 0.75 0.758 0.77 0.775];
             eta=interp1(etatab(1,:),etatab(2,:),SF,'linear','extrap');
             if eta>1;
                 eta=1;
             end
             %eta=-0.0004*SF^2+0.0198*SF+0.525 %From empirical data.
             
             X0=0.55*ln+0.36*lr;
             Bdt1=2*deltak;
             Bdt2=(6/(pi*db^2))*eta*(db/2)*1.2*(lr-X0);
             
             CD(i,2)=Bdt1*alpha^2+Bdt2*alpha^3;

        case 'finset'
            n=varargin{i}{2}(1);
            a=varargin{i}{2}(2);
            b=varargin{i}{2}(3);
            m=varargin{i}{2}(4);
            s=varargin{i}{2}(5);
            t=varargin{i}{2}(6);
            d=varargin{i}{2}(7);

            lc=(m+b)-((m+b-a)/2)-(m/2);% lenght of fin mid chord

            sfa=0.5*(a+b)*s;%single fin area;
            sfp=d*a/2+sfa; %single fin planform;

            fpa=n*sfp;%total fin planform area;
            fea=n*sfa;%total fin exposed area;

            mfac=lc/Ltb;

            Ren=Re*mfac;

            B=Recrit*(0.074/Ren^(1/5)-1.328/sqrt(Ren));

            if Ren<=Recrit;
                Cffin=1.328/sqrt(Ren);
            elseif Ren>Recrit;
                Cffin=0.074/Ren^(1/5)-B/Ren;
            end

            Cdfin=2*Cffin*(1+2*t/lc)*(fpa/(pi*d^2/4));

            Cdint=2*Cffin*(1+2*t/lc)*((fpa-fea)/(pi*d^2/4));

            CD(i,1)=Cdfin+Cdint;
            
            %drag due to angle of attack alpha
            
            Lts=(2*s)+d;
            FAR=s/lc; %fin aspect ratio;
            FSR=d/Lts; %fin section ratio;
            
            Kbf=0.8065*FSR^2+1.1553*FSR;
            Kfb=0.1935*FSR^2+0.8174*FSR+1;
            
            Fidt=fpa*4/(pi*d^2)*1.2;
            Idt=(Kfb+Kbf-1)*3.12*(fea*4/(pi*d^2));
            
            CD(i,2)=(Fidt+Idt)*alpha^2;
    end
end

Cda=sum(CD(:,1));
Cdalpha=sum(CD(:,2));

Cd=(Cda+Cdalpha)*1.1;

if Cd>0.9;
    Cd=0.9;
end


