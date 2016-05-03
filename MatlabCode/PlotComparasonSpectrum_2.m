function [ output ] = PlotComparasonSpectrum_2( normSignalFilename,...
                                                testSignalFilename,...
                                                azimuth,...
                                                elevation,...
                                                fs, x, l, m... 
                                              )
    %% Description of Function =========================================
    
    % This function will recieve the filenames of a normalized audio 
    % file, and a test audio file which should be compared. The function 
    % will load the two files, and plot a comparason of their frequency 
    % spectra in terms of:

    % The actual difference in frequency magnitudes
    % A smoothed out difference in frequency magnitudes
    % Average differnce in frequency magnitudes over a number of octave 
    % bands

    %% User Inputs =====================================================
    
    % Define folder test recordings are held in
    folder = sprintf('Genelec_Full_Recordings/');
    % Define smoothing factor for ploting smoothed comparason 
    % (approx 10,000 for smooth)
    smoothing = 1000;
    
    
    %% Code ============================================================
    
    % Define full filepaths for recordings to be analyzed
    normSignalFilepath = sprintf('%s%s', folder, normSignalFilename);
    testSignalFilepath = sprintf('%s%s', folder, testSignalFilename);
    
    % Read in recordings to be analyzed
    normSignal = audioread(normSignalFilepath);
    testSignal = audioread(testSignalFilepath);
    
    % Test Normal and Test recording are of same length
    if length(normSignal) ~= length(testSignal)
        error(...
        'normal signal %s is NOT of same length as test signal %s',...
        normSignalFilename, testSignalFilename...
        );
    
    else

        % Get length (number of samples) of recordings
        N = length(testSignal);
        
        % Define hanning window
        han = hanning(N);

        % Apply hanning window to recordings to negate "edge" 
        % dicontinuities
        normSignal = normSignal.*han;
        testSignal = testSignal.*han;
        
        % Calculate magnitude of FFT of recordings and convert to dB
        % scale
        normSpectrum = abs(fft(normSignal, N));
        normSpectrum = 20*log10(normSpectrum);
        testSpectrum = abs(fft(testSignal, N));
        testSpectrum = 20*log10(testSpectrum);

        % Calculate difference in spectra
        comparSpectrum = testSpectrum - normSpectrum;
        
        % Apply smoothing Function 
        g = gausswin(smoothing);
        g = g/sum(g);
        smoothComparSpectrum = conv(comparSpectrum, g, 'same');
        
        % Assign Values for frequency axis
        freq_axis = 0:fs/N:fs-(fs/N);
        
        % Calculate sample which corresponds to approx 20,000Hz
        maxPlotSample = round(((16000*(2^(1/2)))*N)/fs);
           
        % Plot graph (log freq) of actual difference between spectra
        subplot(l, m, x), pCS = semilogx(freq_axis(1:maxPlotSample),...
                                    comparSpectrum(1:maxPlotSample));
        hold on;
        
        % Plot graph (log freq) of smoothed / averaged difference 
        % between spectra
        subplot(l, m, x), pSCS = semilogx(freq_axis(1:maxPlotSample),...
                               smoothComparSpectrum(1:maxPlotSample),...
                               'r', 'linewidth', 1);
        
        % re-scale axis to ensure all graphs are equal / comparable
        axis([20,20000,-75,50]);
        graphTitle = sprintf ('Az. = %d%c Elev. = %d%c',...
                              azimuth, char(176), elevation, char(176));
        title(graphTitle);
        
        
        % Calculate samples which correspond to upper and lower bounds 
        % of octave bands
        freq22_1HzSample    = round((( 31.25 / (2^(1/2)))*N)/fs);
        freq44_2HzSample    = round((( 62.5  / (2^(1/2)))*N)/fs);
        freq88_4HzSample    = round((( 125   / (2^(1/2)))*N)/fs);
        freq176_8HzSample   = round((( 250   / (2^(1/2)))*N)/fs);
        freq353_6HzSample   = round((( 500   / (2^(1/2)))*N)/fs);
        freq707_1HzSample   = round((( 1000  / (2^(1/2)))*N)/fs);
        freq1414_2HzSample  = round((( 2000  / (2^(1/2)))*N)/fs);
        freq2828_4HzSample  = round((( 4000  / (2^(1/2)))*N)/fs);
        freq5656_9HzSample  = round((( 8000  / (2^(1/2)))*N)/fs);
        freq11313_7HzSample = round((( 16000 / (2^(1/2)))*N)/fs);
        freq22627_4HzSample = round((( 16000 * (2^(1/2)))*N)/fs);
        
        % Select function to use for averaging in octave band responce
        % (Actual diffrence, or Smoothed difference)
        outputAverageVector = comparSpectrum;
        
        % Calculate octave band averages
        output(1)  = mean...
        (outputAverageVector(freq22_1HzSample   :freq44_2HzSample   ));
        output(2)  = mean...
        (outputAverageVector(freq44_2HzSample   :freq88_4HzSample   ));
        output(3)  = mean...
        (outputAverageVector(freq88_4HzSample   :freq176_8HzSample  ));
        output(4)  = mean...
        (outputAverageVector(freq176_8HzSample  :freq353_6HzSample  ));
        output(5)  = mean...
        (outputAverageVector(freq353_6HzSample  :freq707_1HzSample  ));
        output(6)  = mean...
        (outputAverageVector(freq707_1HzSample  :freq1414_2HzSample ));
        output(7)  = mean...
        (outputAverageVector(freq1414_2HzSample :freq2828_4HzSample ));
        output(8)  = mean...
        (outputAverageVector(freq2828_4HzSample :freq5656_9HzSample ));
        output(9)  = mean...
        (outputAverageVector(freq5656_9HzSample :freq11313_7HzSample));
        output(10) = mean...
        (outputAverageVector(freq11313_7HzSample:freq22627_4HzSample));
        
        % Save Octave band averages in order to plot alongside 
        % actual / smoothed differeces
        plottingOctaveBandAverageResponse...
        ( 1                   : freq22_1HzSample    ) = NaN;
        plottingOctaveBandAverageResponse...
        ( freq22_1HzSample    : freq44_2HzSample    ) = output(1);
        plottingOctaveBandAverageResponse...
        ( freq44_2HzSample    : freq88_4HzSample    ) = output(2);
        plottingOctaveBandAverageResponse...
        ( freq88_4HzSample    : freq176_8HzSample   ) = output(3);
        plottingOctaveBandAverageResponse...
        ( freq176_8HzSample   : freq353_6HzSample   ) = output(4);
        plottingOctaveBandAverageResponse...
        ( freq353_6HzSample   : freq707_1HzSample   ) = output(5);
        plottingOctaveBandAverageResponse...
        ( freq707_1HzSample   : freq1414_2HzSample  ) = output(6);
        plottingOctaveBandAverageResponse...
        ( freq1414_2HzSample  : freq2828_4HzSample  ) = output(7);
        plottingOctaveBandAverageResponse...
        ( freq2828_4HzSample  : freq5656_9HzSample  ) = output(8);
        plottingOctaveBandAverageResponse...
        ( freq5656_9HzSample  : freq11313_7HzSample ) = output(9);
        plottingOctaveBandAverageResponse...
        ( freq11313_7HzSample : freq22627_4HzSample ) = output(10);
        
        % Plot Octave band averages
        subplot(l, m, x),...
            pOBAR = semilogx(freq_axis(1:maxPlotSample),...
                    plottingOctaveBandAverageResponse,...
                    'g', 'linewidth', 1);
 
        % Re-order plots to improve analytical capabilities
        uistack(pSCS, 'top');
    end
end
