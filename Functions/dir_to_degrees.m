function w_dir = dir_to_degrees(w_dir)
switch w_dir
    case 'N'
        dir = 0;
    case 'NNE'
        dir = 1;
    case 'NE'
        dir = 2;
    case 'ENE'
        dir = 3;
    case 'E'
        dir = 4;
    case 'ESE'
        dir = 5;
    case 'SE'
        dir = 6;
    case 'SSE'
        dir = 7;
    case 'S'
        dir = 8;
    case 'SSW'
        dir = 9;
    case 'SW'
        dir = 10;
    case 'WSW'
        dir = 11;
    case 'W'
        dir = 12;
    case 'WNW'
        dir = 13;
    case 'NW'
        dir = 14;
    case 'NNW'
        dir = 15;
end
w_dir = 22.5*dir;
end