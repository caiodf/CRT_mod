function [] = simulate_motor_failure(motor)
close all
time = motor{3}(:,1);
thrust = motor{3}(:,2);
mass = motor{3}(:,3);

figure
plot(time,thrust)
hold on

thrust_efficiency = 0.7;
thrust_real = thrust * thrust_efficiency;

plot(time,thrust_real)


% thrust_peak = 


end