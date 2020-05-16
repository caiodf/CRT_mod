function ATM = CAIO_atmosphere(altitude_vector, ...
                               average_wind_velocity, ...
                               average_wind_direction, ...
                               average_wind_temperature, ...
                               reference_parameters, ...
                               random_parameters, ...
                               plot_bool)
                           
    alt = altitude_vector;
    awv = average_wind_velocity;
    awd = average_wind_direction;
    awt = average_wind_temperature;

    h = reference_parameters(1); %reference height 
    z = reference_parameters(2); %reference roughness
    
    rand_v = random_parameters(1); % percentual variation in velocity
    rand_d = random_parameters(2); % degrees from true north variation in direction
    rand_t = random_parameters(3); % percentual variation in temperature
    
    avg_vel = (awv/ log(h/z)) .* log(alt/z); % log wind profile   
    rand_vel = (awv-rand_v*awv) + 2*rand_v*awv*rand(size(alt));
    vel =  avg_vel + rand_vel; % log profile + random variation
    
    dir = awd-rand_d + 2*rand_d*rand(size(alt));
    % average direction + random variation
    
    temp = (awt-rand_t*awt) + 2*rand_t*awt*rand(size(alt));
    % averge temperature + random variation
    
    if plot_bool == 'yes'
        % Plot das variáveis atmosféricas
        figure(4);
        % velocidade x altitude
        subplot(1,3,1)
        plot(vel, alt, '-k')
        set(gca,'XMinorTick','on','YMinorTick','on')
        grid on
        ylabel('Altitude (m)')
        xlabel('Speed (m/s)')
        % direção x altitude
        subplot(1,3,2)
        plot(dir, alt, '-b')
        set(gca, 'YTickLabel', [])
        set(gca,'XMinorTick','on','YMinorTick','on')
        grid on
        xlabel('Wind Direction (°)')
        title('Atmospheric Properties')
        % temperatura x altitude
        subplot(1,3,3)
        plot(temp, alt, '-r')
        set(gca, 'YTickLabel', [])
        set(gca,'XMinorTick','on','YMinorTick','on')
        grid on
        xlabel('Temperature (°C)')
    end%if
        
    ATM = [3.2808*alt dir 1.944*vel temp];
    % ATM == F124 format [feet angles(true north) knots celsius]
                           
                           
                           
                                