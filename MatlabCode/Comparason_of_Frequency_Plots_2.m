% Format of saved recording's filenames
% u_1_0_0_N.wav
% (sound)_(Repeat)_(azimuth)_(elevation)_(Normal / Test Recording).wav

%% Description of Code =================================================
    
    % This code will analyse a set of recordings made over 3 dimentions 
    % in an attempt to identify a source's Frequency-banded Angular 
    % Directionality - FAD.
    % Graphs will be produced indicating the differences in frequency
    % spectrum from a microphone placed at Azimuth = 0, Elevation = 0 
    % and a microphone placed at a test location. 
    % Octave band averaging will then take place and result in the 
    % output of data tables and polar plots produced for each of the 
    % three planes being analysed. 
    % Polar plots will be split into low frequencies (below 176.8Hz) 
    % and normal frequencies (176.8Hz - 22627.4Hz).
    %
    % Octave Bands found at
    % Ref: http://apmr.matelys.com/Standards/OctaveBands.html 
 
        
%% User Inputs =========================================================    
    
% Select Sound to Analyse
sound = '';
graphTitleSound = '';

% Select Repeat to Analyse
repeat = 1;


%% Definitions =========================================================

% Sampling frequency used in recordings
fs = 96000;

% Declare matricies used for polar plots
zPlaneOctaveBandResponse = zeros(37, 10);
yPlaneOctaveBandResponse = zeros(17, 10);
xPlaneOctaveBandResponse = zeros(17, 10);


%% Recording Analysis ==================================================
% ----------------------------------------------------------------------
%
% Analyze the z plane
%

% Print status report
fprintf('\nAnalyzing the Z-Plane\n');

% Begin a new figure
figure;

% Initiate counter and define plot array dimentions
x = 1;
l = 5;
m = 8;

% Analyse recordings
for phi = 0:10:360
        
    % Calculate filenames
    azimuth = phi;
    elevation = 0;
    normalized_filename = sprintf('%s_%d_%d_%d_N.wav', sound, repeat,... 
                                  azimuth,elevation);
    test_filename       = sprintf('%s_%d_%d_%d_T.wav', sound, repeat,... 
                                  azimuth,elevation);

    % Print status report
    disp(['Comparing ' normalized_filename ' with ' test_filename '']);

    % Plot comparason and save to array
    zPlaneOctaveBandResponse(x, :) = PlotComparasonSpectrum_2(...
                                         normalized_filename,...
                                         test_filename,...
                                         azimuth,...
                                         elevation,...
                                         fs, x, l, m...
                                     );

    % Update counter
    x = x + 1;
end
hold off;


%-----------------------------------------------------------------------
%
% Analyze the y plane
%

fprintf('\nAnalyzing the Y-Plane\n');
figure;
x = 1;
l = 4;
m = 5;
for theta = -160:20:160
        
    azimuth = 0;
    elevation = theta;
    normalized_filename = sprintf('%s_%d_%d_%d_N.wav', sound, repeat,...
                                  azimuth,elevation);
    test_filename       = sprintf('%s_%d_%d_%d_T.wav', sound, repeat,...
                                  azimuth,elevation);

    disp(['Comparing ' normalized_filename ' with ' test_filename '']);
    yPlaneOctaveBandResponse(x, :) = PlotComparasonSpectrum_2(...
                                         normalized_filename,...
                                         test_filename,...
                                         azimuth,...
                                         elevation,...
                                         fs, x, l, m...
                                     );

    x = x + 1;
end
hold off;


% ----------------------------------------------------------------------
%
% Analyze the x plane
%

fprintf('\nAnalyzing the X-Plane\n');
figure;
x = 1;
l = 4;
m = 5;
for theta = -160:20:160
        
    azimuth = 90;
    elevation = theta;
    normalized_filename = sprintf('%s_%d_%d_%d_N.wav', sound, repeat,...
                                  azimuth,elevation);
    test_filename       = sprintf('%s_%d_%d_%d_T.wav', sound, repeat,...
                                   azimuth,elevation);

    disp(['Comparing ' normalized_filename ' with ' test_filename '']);
    xPlaneOctaveBandResponse(x, :) = PlotComparasonSpectrum_2(...
                                         normalized_filename,...
                                         test_filename,...
                                         azimuth,...
                                         elevation,...
                                         fs, x, l, m...
                                     );

    x = x + 1;
end
hold off;

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
          'string', 'Z-Plane Responce in dB relative to 0 degrees',...
          'Position', [10 690 820 20]);
uitable('data', zPlaneOctaveBandResponse,... 
        'RowName', zPlaneDegString, ...
        'ColumnName', octaveBands,...
        'ColumnWidth', {75},...
        'Position',[10 10 820 670]);

    
% ----------------------------------------------------------------------
%
% Y - Plane 
%

% Exclude N/A recordings where body blocking occured
% yPlaneOctaveBandResponse(3:4, :) = NaN; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
yPlaneDegString = cell(17, 1);
stepper = 1;
for deg = -160:20:160
    
    string = cellstr(sprintf('%d%c', deg, char(176)));
    yPlaneDegString(stepper) = string;
    stepper = stepper + 1;
    
end

uicontrol('style', 'text',...
          'string', 'Y-Plane Responce in dB relative to 0 degrees',...
          'Position', [10 360 820 20]);
uitable('data', yPlaneOctaveBandResponse,... 
        'RowName', yPlaneDegString, ...
        'ColumnName', octaveBands,...
        'ColumnWidth', {75},...
        'Position',[10 10 830 340]);
    
    
% ----------------------------------------------------------------------
%
% X - Plane 
%   
    
% xPlaneOctaveBandResponse(4:5, :) = NaN; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
xPlaneDegString = cell(17, 1);
stepper = 1;
for deg = -160:20:160
    
    string = cellstr(sprintf('%d%c', deg, char(176)));
    xPlaneDegString(stepper) = string;
    stepper = stepper + 1;
    
end

uicontrol('style', 'text',...
          'string', 'X-Plane Responce in dB relative to 0 degrees',...
          'Position', [10 360 820 20]);
uitable('data', xPlaneOctaveBandResponse,... 
        'RowName', xPlaneDegString, ...
        'ColumnName', octaveBands,...
        'ColumnWidth', {75},...
        'Position',[10 10 830 340]);
    
    
%% Manipulate Data for Polar Plots =====================================

fprintf('\nManipulating Data for Polar Plots');

% ----------------------------------------------------------------------
%
% Z- Plane 
%

% Calculate angle array 
zangle = 0 : 2*pi/36 : 2*pi;

% Add offset to data in order to plot correctly on polar plot 
% (positive values only)
zoffset = -40;
zPlaneOctaveBandResponse = zPlaneOctaveBandResponse - zoffset;

% ----------------------------------------------------------------------
%
% Y- Plane
%

yangle = 0 : 2*pi/18 : 2*pi;

% Re-order data in matrix and insert data from other matricies to 
% prepare a full 360 degree plot on a polar chart
temp = yPlaneOctaveBandResponse(1:8, :);
yPlaneOctaveBandResponse(1:9, :) = yPlaneOctaveBandResponse(9:17, :);
yPlaneOctaveBandResponse(10, :) = zPlaneOctaveBandResponse(19, :)...
                                  + zoffset;
yPlaneOctaveBandResponse(11:18, :) = temp(1:8, :);
yPlaneOctaveBandResponse(19, :) = zPlaneOctaveBandResponse(37, :)...
                                  + zoffset;

yoffset = -40;
yPlaneOctaveBandResponse = yPlaneOctaveBandResponse - yoffset;

% ----------------------------------------------------------------------
%
% X- Plane
%

xangle = 0 : 2*pi/18 : 2*pi;

temp = xPlaneOctaveBandResponse(1:8, :);
xPlaneOctaveBandResponse(1:9, :) = xPlaneOctaveBandResponse(9:17, :);
xPlaneOctaveBandResponse(10, :) = zPlaneOctaveBandResponse(28, :)...
                                  + zoffset;
xPlaneOctaveBandResponse(11:18, :) = temp(1:8, :);
xPlaneOctaveBandResponse(19, :) = zPlaneOctaveBandResponse(10, :)...
                                  + zoffset;

xoffset = -40;
xPlaneOctaveBandResponse = xPlaneOctaveBandResponse - xoffset;


%% Plot Polar Plots ====================================================

fprintf('\nProducing Polar Plots')

% ----------------------------------------------------------------------
%
% Plot Z-Plane Polar graph
%

% New figure
figure;

% Plot dummy circular line to ensure correct axis scalling of plot
p = polar(zangle, (ones(1, 37) * -zoffset) + 1);

% Hide dummy line
set(p, 'Visible', 'off');
hold on;

% Plot low frequency octave bands 
p0 = polar(zangle, (ones(1, 37) * -zoffset), 'k');             
p1 = polar(zangle, zPlaneOctaveBandResponse(:, 1).', 'b');     
p2 = polar(zangle, zPlaneOctaveBandResponse(:, 2).', 'r');     
p3 = polar(zangle, zPlaneOctaveBandResponse(:, 3).', 'g');     
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
p = polar(zangle, (ones(1, 37) * -zoffset) + 1);
set(p, 'Visible', 'off');
hold on;

% Plot normal frequency octave bands 
p0 = polar(zangle, (ones(1, 37) * -zoffset), 'k');             
p4 = polar(zangle, zPlaneOctaveBandResponse(:, 4).', 'b');     
p5 = polar(zangle, zPlaneOctaveBandResponse(:, 5).', 'r');     
p6 = polar(zangle, zPlaneOctaveBandResponse(:, 6).', 'g');     
p7 = polar(zangle, zPlaneOctaveBandResponse(:, 7).', '--b');   
p8 = polar(zangle, zPlaneOctaveBandResponse(:, 8).', '--r');   
p9 = polar(zangle, zPlaneOctaveBandResponse(:, 9).', '--g');   
p10 = polar(zangle, zPlaneOctaveBandResponse(:, 10).', ':b');  
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
p = polar(yangle, (ones(1, 19) * -yoffset) + 1);
set(p, 'Visible', 'off');
hold on;
p0 = polar(yangle, (ones(1, 19) * -yoffset), 'k');            
p1 = polar(yangle, yPlaneOctaveBandResponse(:, 1).', 'b'); 
p2 = polar(yangle, yPlaneOctaveBandResponse(:, 2).', 'r');
p3 = polar(yangle, yPlaneOctaveBandResponse(:, 3).', 'g');
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
p = polar(yangle, (ones(1, 19) * -yoffset) + 1);
set(p, 'Visible', 'off');
hold on;
p0 = polar(yangle, (ones(1, 19) * -yoffset), 'k');
p4 = polar(yangle, yPlaneOctaveBandResponse(:, 4).', 'b');   
p5 = polar(yangle, yPlaneOctaveBandResponse(:, 5).', 'r');   
p6 = polar(yangle, yPlaneOctaveBandResponse(:, 6).', 'g');    
p7 = polar(yangle, yPlaneOctaveBandResponse(:, 7).', '--b');    
p8 = polar(yangle, yPlaneOctaveBandResponse(:, 8).', '--r');    
p9 = polar(yangle, yPlaneOctaveBandResponse(:, 9).', '--g');    
p10 = polar(yangle, yPlaneOctaveBandResponse(:, 10).', ':b');   
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
p = polar(xangle, (ones(1, 19) * -xoffset) + 1);
set(p, 'Visible', 'off');
hold on;
p0 = polar(xangle, (ones(1, 19) * -xoffset), 'k');             
p1 = polar(xangle, xPlaneOctaveBandResponse(:, 1).', 'b'); 
p2 = polar(xangle, xPlaneOctaveBandResponse(:, 2).', 'r');
p3 = polar(xangle, xPlaneOctaveBandResponse(:, 3).', 'g');
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
p = polar(xangle, (ones(1, 19) * -xoffset) + 1);
set(p, 'Visible', 'off');
hold on;
p0 = polar(xangle, (ones(1, 19) * -xoffset), 'k');
p4 = polar(xangle, xPlaneOctaveBandResponse(:, 4).', 'b');   
p5 = polar(xangle, xPlaneOctaveBandResponse(:, 5).', 'r');    
p6 = polar(xangle, xPlaneOctaveBandResponse(:, 6).', 'g');    
p7 = polar(xangle, xPlaneOctaveBandResponse(:, 7).', '--b');    
p8 = polar(xangle, xPlaneOctaveBandResponse(:, 8).', '--r');    
p9 = polar(xangle, xPlaneOctaveBandResponse(:, 9).', '--g');    
p10 = polar(xangle, xPlaneOctaveBandResponse(:, 10).', ':b');  
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