% GAUSS_ELLIPSE	Draw a 2D ellipse of constant Mahalanobis distance.
% (Thanks: Mike Tipping).

function handle = gauss_ellipse(mu, Sigma, dist, colour)

nplot = 30;    
theta	= [0:2*pi/(nplot-1):2*pi]';
n	= size(theta,1);
d	= size(Sigma,1);
r	= ones(n,1)*dist;
[x1 x2]	= pol2cart(theta,r);

Z = [x1 x2]* Sigma^(0.5) + ones(n,1)*mu;

handle = plot(Z(:,1),Z(:,2),colour, 'linewidth', 3);

