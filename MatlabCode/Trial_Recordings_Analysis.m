% Format of saved recording's filenames
% u_1_0_0_N.wav
% (sound)_(Repeat)_(azimuth)_(elevation)_(Normal / Test Recording).wav

% ======================================================================

fs = 96000;

% Select Sound to Analyse
sound = 'u';
% Select Repeat to Analyse
repeat = 1;

% Analyze the z plane
disp(sprintf('\nAnalyzing the Z-Plane'));
figure;
x = 1;
l = 2;
m = 4;
for phi = 45:45:315

    azimuth = phi;
    elevation = 0;
    normalized_filename = sprintf('%s_%d_%d_%d_N.wav', sound,...
                                  repeat, azimuth,elevation...
                                 );
    test_filename = sprintf('%s_%d_%d_%d_T.wav', sound,...
                            repeat, azimuth,elevation...
                           );

    disp(['Comparing ' normalized_filename...
          ' with ' test_filename '']);
    PlotComparasonSpectrum(normalized_filename,...
                           test_filename, fs, x, l, m);
    plotTitle = sprintf('Azimuth = %d\nElevation = %d',...
                        azimuth, elevation);
    title(plotTitle);
    x = x + 1;
        
end

