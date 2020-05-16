function F=AnimateRocket(AscentData)

clc;
disp(sprintf('//******************************************//'));
disp(sprintf('//******************************************//'));
disp(sprintf('\n\n***ROCKET FLIGHT SIMULATOR***'));
disp(sprintf('\n\nFLIGHT ANIMATION MENU'));


%Extract Data from ascent calc
z = AscentData(:,2:4);
Q = AscentData(:,5:8);

%Thin Down the data to match 30fps
tlim = AscentData(end,1);
FPS=length(z(:,1))/tlim;
DIV=floor(FPS/12);

Z={};
q={};
for i=1:DIV:length(z(:,1))
    Z{end+1}=z(i,:);
    q{end+1}=Q(i,:);
end
clear z;
clear Q;
for i=1:length(Z)
    z(i,:)=Z{i};
    Q(i,:)=q{i};
end

%Points that define the rocket
Points = {
    [0;0;0],
    [0;0;3],
    [1.5;0;-1.5],
    [0;1.5;-1.5],
    [-1.5;0;-1.5],
    [0;-1.5;-1.5]
    };



figure(02);

for i=1:length(z(:,1));

    Points = {
    [0;0;0],
    [0;0;3],
    [1.5;0;-1.5],
    [0;1.5;-1.5],
    [-1.5;0;-1.5],
    [0;-1.5;-1.5]
    };

    zi = z(i,:);
    qi = Q(i,:);

    R=quaternion_to_matrix(qi);
    if i == 900
        A=3.0;
    end
    for j=1:length(Points)
        Points{j}=R*Points{j};
        Points{j}=Points{j}+zi';
    end

    for j = 1:5
        X{j}={[Points{1}(1),Points{j+1}(1)],[Points{1}(2),Points{j+1}(2)],[Points{1}(3),Points{j+1}(3)]};
    end

    plot3(X{1}{1},X{1}{2},X{1}{3},'b',X{2}{1},X{2}{2},X{2}{3},'r',X{3}{1},X{3}{2},X{3}{3},'g',X{4}{1},X{4}{2},X{4}{3},'c',X{5}{1},X{5}{2},X{5}{3},'k','Linewidth',2);
%     axis equal
    set(gca,'xlim',[(min(z(:,1))-10) (max(z(:,1))+10)])
    set(gca,'ylim',[(min(z(:,2))-10) (max(z(:,2))+10)])
    %set(gca,'xlim',[-500 500])
    %set(gca,'ylim',[-100 100])
    if i < length(z(:,1)) - 5
        set(gca,'zlim',[min(z(i:i+5,3))-10 max(z(i:i+5,3))+10])
    else
        set(gca,'zlim',[min(z(end-5:end,3))-10 max(z(end-5:end,3))+10])
    end
    %set(gca,'zlim',[0 500])
    xlabel('East (m)')
    ylabel('North (m)')
    zlabel('Altitude (m)')
    title('Flight Path')
    set(gca,'XGrid','on')
    set(gca,'YGrid','on')
    set(gca,'ZGrid','on')
    F(i) = getframe();

end
disp(sprintf('\n1. Replay the animation.'));
disp(sprintf('2. Run the simulation again.'));
disp(sprintf('3. Return to the main menu.'));

play = true;
while play == true
    movie(F,1);
    stop = false;
    while stop == false
        disp(sprintf('\nPlease enter the number of an option from the animation menu and press return.'));

        Ucodes = input(':>','s');
        Ucode = str2num(Ucodes);
        Ucode = uint8(Ucode);

        if (~isempty(Ucode) && Ucode>=1 && Ucode<=3)
            stop = true;
        else
            disp(sprintf(['!! Sorry ',Ucodes,' is not a recognized menu item please try again']));
        end
    end
    
    if (Ucode ==1)
    else
        play = false;
    end
    
end
if (Ucode == 2)
    FlyRocketMenu();
elseif (Ucode ==3 )
    Main_Menu();
else
    disp(sprintf('Something went wrong with the post simulation menu selection'));
end
