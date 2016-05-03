%% User input ==========================================================

folder = '../2.3) Data Tables Analysis/0.0) Direct From Matlab/';

%% Definitions =========================================================

offset = -40;
zangle = 0 : 2*pi/36 : 2*pi;
xangle = 0 : 2*pi/18 : 2*pi;
yangle = 0 : 2*pi/18 : 2*pi;
graphTitleSound = 'Human Avg.';

%% Extract Data ========================================================
% ----------------------------------------------------------------------
%
% Extract for X-Plane
%

% Get Data from /u:/ sound - xPlane
file_to_open = sprintf('%shuman, u/u_xPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_u_x =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);

% Get Data from /i:/ sound - xPlane
file_to_open = sprintf('%shuman, i/i_xPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_i_x =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);

% Get Data from /a:/ sound - xPlane
file_to_open = sprintf('%shuman, a/a_xPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_a_x =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);

% ----------------------------------------------------------------------
%
% Extract for Y-Plane
%
% Get Data from /u:/ sound - yPlane
file_to_open = sprintf('%shuman, u/u_yPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_u_y =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);

% Get Data from /i:/ sound - yPlane
file_to_open = sprintf('%shuman, i/i_yPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_i_y =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);

% Get Data from /a:/ sound - yPlane
file_to_open = sprintf('%shuman, a/a_yPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_a_y =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);

% ----------------------------------------------------------------------
%
% Extract for Z-Plane
%
% Get Data from /u:/ sound - zPlane
file_to_open = sprintf('%shuman, u/u_zPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_u_z =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);

% Get Data from /i:/ sound - zPlane
file_to_open = sprintf('%shuman, i/i_zPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_i_z =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);

% Get Data from /a:/ sound - zPlane
file_to_open = sprintf('%shuman, a/a_zPlane_data.fig', folder);
open(file_to_open);
table_data_fig = findobj(gcf,'Type','uitable');
if strcmpi( get(table_data_fig,'type'), 'uitable'),  %x is uitable
   data_a_z =get(table_data_fig,'Data');   %this is the uitable data
end
close(gcf);


%% Combine and Average Sound Data for Each Plane

combined_matricies = cat(3, data_u_x, data_i_x, data_a_x);
mean_data_x = mean(combined_matricies, 3);

combined_matricies = cat(3, data_u_y, data_i_y, data_a_y);
mean_data_y = mean(combined_matricies, 3);

combined_matricies = cat(3, data_u_z, data_i_z, data_a_z);
mean_data_z = mean(combined_matricies, 3);


%% Produce Data Tables =================================================

fprintf('\nProducing Data Tables');

octaveBands = {'31.5Hz' ,'63Hz'   ,'125Hz'  ,'250Hz'  ,'500Hz'   ,...
               '1,000Hz','2,000Hz','4,000Hz','8,000Hz','16,000Hz'};

% ----------------------------------------------------------------------
%
% Z - Plane 
%

% New figure
figure;

% Create array to hold row lables
zPlaneDegString = cell(37, 1);
stepper = 1;
for deg = 0:10:360
    
    string = cellstr(sprintf('%d%c', deg, char(176)));
    zPlaneDegString(stepper) = string;
    stepper = stepper + 1;
    
end

% Produce data table with title for identification
uicontrol('style', 'text',...
          'string',...
          'Average Z-Plane Responce in dB relative to 0 degrees',...
          'Position', [10 690 820 20]);
uitable('data', mean_data_z,... 
        'RowName', zPlaneDegString, ...
        'ColumnName', octaveBands,...
        'ColumnWidth', {75},...
        'Position',[10 10 820 670]);

    
% ----------------------------------------------------------------------
%
% Y - Plane 
%


figure;
yPlaneDegString = cell(17, 1);
stepper = 1;
for deg = -160:20:160
    
    string = cellstr(sprintf('%d%c', deg, char(176)));
    yPlaneDegString(stepper) = string;
    stepper = stepper + 1;
    
end

uicontrol('style', 'text',...
          'string',...
          'Average Y-Plane Responce in dB relative to 0 degrees',...
          'Position', [10 360 820 20]);
uitable('data', mean_data_y,... 
        'RowName', yPlaneDegString, ...
        'ColumnName', octaveBands,...
        'ColumnWidth', {75},...
        'Position',[10 10 830 340]);
    
    
% ----------------------------------------------------------------------
%
% X - Plane 
%   


figure;
xPlaneDegString = cell(17, 1);
stepper = 1;
for deg = -160:20:160
    
    string = cellstr(sprintf('%d%c', deg, char(176)));
    xPlaneDegString(stepper) = string;
    stepper = stepper + 1;
    
end

uicontrol('style', 'text',...
          'string',...
          'Average X-Plane Responce in dB relative to 0 degrees',...
          'Position', [10 360 820 20]);
uitable('data', mean_data_x,... 
        'RowName', xPlaneDegString, ...
        'ColumnName', octaveBands,...
        'ColumnWidth', {75},...
        'Position',[10 10 830 340]);
    
    
%% Manipulate Data for Plotting ========================================
% ----------------------------------------------------------------------
%
% Offset Data to enable plotting on 'polar' axis
%
mean_data_x = mean_data_x - offset;

mean_data_y = mean_data_y - offset;

mean_data_z = mean_data_z - offset;

% ----------------------------------------------------------------------
%
% Manipulate sound data
%
temp = mean_data_y(1:8, :);
mean_data_y(1:9, :) = mean_data_y(9:17, :);
mean_data_y(10, :) = mean_data_z(19, :);
mean_data_y(11:18, :) = temp(1:8, :);
mean_data_y(19, :) = mean_data_z(37, :);

temp = mean_data_x(1:8, :);
mean_data_x(1:9, :) = mean_data_x(9:17, :);
mean_data_x(10, :) = mean_data_z(28, :);
mean_data_x(11:18, :) = temp(1:8, :);
mean_data_x(19, :) = mean_data_z(10, :);

%% Plot Average Graphs =================================================
% ----------------------------------------------------------------------
%
% Plot Z-Plane Polar graph
%

% New figure
figure;

% Plot dummy circular line to ensure correct axis scalling of plot
p = polar(zangle, (ones(1, 37) * -offset) + 1);

% Hide dummy line
set(p, 'Visible', 'off');
hold on;

% Plot low frequency octave bands 
p0 = polar(zangle, (ones(1, 37) * -offset), 'k'); % black
p1 = polar(zangle, mean_data_z(:, 1).', 'b');     % blue
p2 = polar(zangle, mean_data_z(:, 2).', 'r');     % red
p3 = polar(zangle, mean_data_z(:, 3).', 'g');     % green
hold off;

% Set title for low frequency octave band plot
graphTitle = ... 
    sprintf(...
    'Source: %s, Z-Plane: Azimuth = plotted, Elevation = 0%c',...
    graphTitleSound, char(176)...
    );
title(graphTitle);

% Re-label axis so correct values are shown
set(findall(gca, 'String', '  50'),'String', '+10 dB');
set(findall(gca, 'String', '  40'),'String', '  0 dB');
set(findall(gca, 'String', '  30'),'String', '-10 dB');
set(findall(gca, 'String', '  20'),'String', '-20 dB');
set(findall(gca, 'String', '  10'),'String', '-30 dB');

% show ledgend
legend([p0, p1, p2, p3], '0dB Marker', '31.5Hz','63Hz','125Hz',...
       'location', 'northwestoutside');

% Create a new figure
figure;
p = polar(zangle, (ones(1, 37) * -offset) + 1);
set(p, 'Visible', 'off');
hold on;

% Plot normal frequency octave bands 
p0 = polar(zangle, (ones(1, 37) * -offset), 'k'); % black
p4 = polar(zangle, mean_data_z(:, 4).', 'b');     % blue
p5 = polar(zangle, mean_data_z(:, 5).', 'r');     % red
p6 = polar(zangle, mean_data_z(:, 6).', 'g');     % green
p7 = polar(zangle, mean_data_z(:, 7).', '--b');   % dashed blue
p8 = polar(zangle, mean_data_z(:, 8).', '--r');   % dashed red
p9 = polar(zangle, mean_data_z(:, 9).', '--g');   % dashed green
p10 = polar(zangle, mean_data_z(:, 10).', ':b');  % dotted blue
hold off;

graphTitle = ...
    sprintf(...
    'Source: %s, Z-Plane: Azimuth = plotted, Elevation = 0%c',...
    graphTitleSound, char(176)...
    );
title(graphTitle);
set(findall(gca, 'String', '  50'),'String', '+10 dB');
set(findall(gca, 'String', '  40'),'String', '  0 dB');
set(findall(gca, 'String', '  30'),'String', '-10 dB');
set(findall(gca, 'String', '  20'),'String', '-20 dB');
set(findall(gca, 'String', '  10'),'String', '-30 dB');
legend([p0, p4, p5, p6, p7, p8, p9, p10],...
       '0dB Marker', '250Hz','500Hz' ,'1000Hz' ,...
       '2000Hz'    ,'4000Hz','8000Hz','16000Hz',...
       'location', 'northwestoutside');


% ----------------------------------------------------------------------
%
% Plot Y-Plane Polar graph
%

figure;
p = polar(yangle, (ones(1, 19) * -offset) + 1);
set(p, 'Visible', 'off');
hold on;
p0 = polar(yangle, (ones(1, 19) * -offset), 'k');            
p1 = polar(yangle, mean_data_y(:, 1).', 'b'); 
p2 = polar(yangle, mean_data_y(:, 2).', 'r');
p3 = polar(yangle, mean_data_y(:, 3).', 'g');
hold off;

graphTitle = ...
    sprintf(...
    'Source: %s, Y-Plane: Azimuth = 0%c, Elevation = plotted',...
    graphTitleSound, char(176)...
    );
title(graphTitle);
set(findall(gca, 'String', '  50'),'String', '+10 dB');
set(findall(gca, 'String', '  40'),'String', '  0 dB');
set(findall(gca, 'String', '  30'),'String', '-10 dB');
set(findall(gca, 'String', '  20'),'String', '-20 dB');
set(findall(gca, 'String', '  10'),'String', '-30 dB');
legend([p0, p1, p2, p3], '0dB Marker', '31.5Hz','63Hz','125Hz',...
       'location', 'northwestoutside');

figure;
p = polar(yangle, (ones(1, 19) * -offset) + 1);
set(p, 'Visible', 'off');
hold on;
p0 = polar(yangle, (ones(1, 19) * -offset), 'k');
p4 = polar(yangle, mean_data_y(:, 4).', 'b');   
p5 = polar(yangle, mean_data_y(:, 5).', 'r');   
p6 = polar(yangle, mean_data_y(:, 6).', 'g');    
p7 = polar(yangle, mean_data_y(:, 7).', '--b');    
p8 = polar(yangle, mean_data_y(:, 8).', '--r');    
p9 = polar(yangle, mean_data_y(:, 9).', '--g');    
p10 = polar(yangle, mean_data_y(:, 10).', ':b');   
hold off;

graphTitle = ...
    sprintf(...
    'Source: %s, Y-Plane: Azimuth = 0%c, Elevation = plotted',...
    graphTitleSound, char(176)...
    );
title(graphTitle);
set(findall(gca, 'String', '  50'),'String', '+10 dB');
set(findall(gca, 'String', '  40'),'String', '  0 dB');
set(findall(gca, 'String', '  30'),'String', '-10 dB');
set(findall(gca, 'String', '  20'),'String', '-20 dB');
set(findall(gca, 'String', '  10'),'String', '-30 dB');
legend([p0, p4, p5, p6, p7, p8, p9, p10],...
    '0dB Marker', '250Hz','500Hz' ,'1000Hz' ,...
    '2000Hz'    ,'4000Hz','8000Hz','16000Hz',...
    'location', 'northwestoutside');


% ----------------------------------------------------------------------
%
% Plot X-Plane Polar graph
%

figure;
p = polar(xangle, (ones(1, 19) * -offset) + 1);
set(p, 'Visible', 'off');
hold on;
p0 = polar(xangle, (ones(1, 19) * -offset), 'k');             
p1 = polar(xangle, mean_data_x(:, 1).', 'b'); 
p2 = polar(xangle, mean_data_x(:, 2).', 'r');
p3 = polar(xangle, mean_data_x(:, 3).', 'g');
hold off;

graphTitle = ...
    sprintf(...
    'Source: %s, X-Plane: Azimuth = 90%c, Elevation = plotted',...
    graphTitleSound, char(176)...
    );
title(graphTitle);
set(findall(gca, 'String', '  50'),'String', '+10 dB');
set(findall(gca, 'String', '  40'),'String', '  0 dB');
set(findall(gca, 'String', '  30'),'String', '-10 dB');
set(findall(gca, 'String', '  20'),'String', '-20 dB');
set(findall(gca, 'String', '  10'),'String', '-30 dB');
legend([p0, p1, p2, p3], '0dB Marker', '31.5Hz','63Hz','125Hz',...
       'location', 'northwestoutside');

figure;
p = polar(xangle, (ones(1, 19) * -offset) + 1);
set(p, 'Visible', 'off');
hold on;
p0 = polar(xangle, (ones(1, 19) * -offset), 'k');
p4 = polar(xangle, mean_data_x(:, 4).', 'b');   
p5 = polar(xangle, mean_data_x(:, 5).', 'r');    
p6 = polar(xangle, mean_data_x(:, 6).', 'g');    
p7 = polar(xangle, mean_data_x(:, 7).', '--b');    
p8 = polar(xangle, mean_data_x(:, 8).', '--r');    
p9 = polar(xangle, mean_data_x(:, 9).', '--g');    
p10 = polar(xangle, mean_data_x(:, 10).', ':b');  
hold off;

graphTitle = ...
    sprintf(...
    'Source: %s, X-Plane: Azimuth = 90%c, Elevation = plotted',...
    graphTitleSound, char(176)...
    );
title(graphTitle);
set(findall(gca, 'String', '  50'),'String', '+10 dB');
set(findall(gca, 'String', '  40'),'String', '  0 dB');
set(findall(gca, 'String', '  30'),'String', '-10 dB');
set(findall(gca, 'String', '  20'),'String', '-20 dB');
set(findall(gca, 'String', '  10'),'String', '-30 dB');
legend([p0, p4, p5, p6, p7, p8, p9, p10],...
       '0dB Marker', '250Hz','500Hz' ,'1000Hz' ,...
       '2000Hz'    ,'4000Hz','8000Hz','16000Hz',...
       'location', 'northwestoutside');

% End of Code ==========================================================
fprintf('\nAnalysis Complete\n');
