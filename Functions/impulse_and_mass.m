function [M,Impulse]=impulse_and_mass(t,T,m)

Impulse = trapz(t,T);
mass_per_impulse = m/Impulse;

M(1) = m;
for i = 2:length(t)
    I(i) = trapz(t(1:i),T(1:i));
    M(i)=m-(mass_per_impulse*I(i));
end

end