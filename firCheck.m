% This function can be used to design a plateau-shaped FIR filter and 
% visually check the filter parameter.
%
% Required input is:
%               firBand:  a two-value vector indicating the plateau zone of
%                         your filter, For example, if you want to filter 
%                         between 18 and 22 Hz, firband = [18 22]
%               firOder:  a scalar, indicating the filter order. For example,
%                         you can replace x by a number (e.g., 3) in 
%                         round(x*(EEG.srate/freqBand(1)));
%               firTrans: a scalar, indicating the transition zone. For
%                         example, input .15 for a transition zone of 15%
%               eegRate:  a scalar, indicating the EEG sampling frequency
%               figureOn: a scalar, indicating if you want to visually
%                         check your filter (0 for no visual inspection and 1 for 
%                         visual inspection)
%
% Output:
%              firWeights: a vector, containing the weights of the filter you created
%
% Author: Clara Ziane. Contact clara.ziane@gmail.com for questions/suggestions

function [firWeights] = firCheck(firBand, firOrder, firTrans, eegRate, figureOn)

nyquistFreq = eegRate/2;
firAmp      = [0 0 1 1 0 0];
firFreq     = [0 (1-firTrans)*firBand(1) firBand(1) firBand(2) firBand(2)*(1+firTrans) nyquistFreq] / nyquistFreq;
firWeights  = firls(firOrder, firFreq, firAmp);

firFFT = abs(fft(firWeights));
freqHz = linspace(0, nyquistFreq, floor(firOrder/2)+1);

if figureOn == 1

    % Plot filter kernel
    figure;
    subplot(211)
    plot((1:firOrder+1)*(1000/eegRate),firWeights')
    xlabel('Time (ms)')
    title('Time-domain filter kernel')

    % Plot ideal filter and designed filter superimposed
    subplot(212)
    plot(freqHz, firFFT(:,1:length(freqHz)))
    hold on;
    plot([0 (1-firTrans)*firBand(1) firBand(1) firBand(2) firBand(2)*(1+firTrans) nyquistFreq], firAmp)
    set(gca, 'xlim', [0 60], 'ylim', [-.1 1.2])
    xlabel('Frequencies (Hz)')
    title('Frequency-domain filter kernel')

end

end