%% *************************************************************************
% Loads all the data files of the type *.s1p and *.s2p in the current
% folder
% Creates figures and png image files
% Figures are stored in the current folder
% Use the function plotSParametersInaFile
%% ****************************************************************************
clear all;
listing=dir('*.s?p'); %Get the files in the folder of type s1p and s2p
nfiles=numel(listing);
FreqMax=1500E6; %Choose maximum frequency: Assumes frequency in Hz (check the units in the s1p and s2p files)

for k=1:nfiles % for each file
    filename=listing(k).name;
    DeviceName=filename(1:end-4);
    plotSParametersInaFile(filename,DeviceName,FreqMax); %Plot the figures
end

function []=plotSParametersInaFile(filename,DeviceName,FreqMax);
%% Reads the S-parameter from the file name
% Uses Device Name to legend or title the figures
% Plots data within the frequency range

% Read the S-Parameters
Erro=false;
try
    disp(filename)
    S = sparameters(filename);
catch
    warning(strcat('Problemas a abrir o ficheiro ',filename))
    Erro=true;
end

if not(Erro)

    % Get the array of frequencies, Characteristic impedance and the number of
    % ports
    f = S.Frequencies;
    Z0=S.Impedance;
    Portas=S.NumPorts;

    % Retrieve the S-Parameters
    S11 = rfparam(S,1,1);
    if Portas==2,    % Medidas two-port two path
        S21= rfparam(S,2,1);
        S22 =rfparam(S,2,2);
        S12= rfparam(S,1,2);
    end;

    %%  Create and store the figures: S11
    idex=find(f<FreqMax);

    %% Input reflection coefficient in a Smith Chart
    figure(1); clf
    smithplot(S11(idex),'Color','k');
    hold on;
    smithplot(S11(min(idex)),'ok');
    smithplot(S11(max(idex)),'*k');

    legend('\rho(f)','f_{min}','f_{max}');
    title(strcat(DeviceName,': S11'));

    saveas(gcf,strcat('SmithS11','-', DeviceName),'png');
    saveas(gcf,strcat('SmithS11','-', DeviceName),'fig');

    %% S11 in logmag units rectangular plot
    figure(2); clf;
    plot(f(idex)/1E6,20.*log10(abs(S11(idex))),'k');
    hold on;

    xlabel('Frequency (Hz)');
    ylabel('S11 (Log. Magnitude) (dB)');
    grid on;
    title(strcat(DeviceName,': S11'));

    saveas(gcf,strcat('LogMagS11','-', DeviceName),'png');
    saveas(gcf,strcat('LogMagS11','-', DeviceName),'fig');

    %% S11 in polar
    figure(3); clf;
    polarplot(S11(idex),'k')
    hold on;
    polarplot(S11(min(idex)),'ok')
    polarplot(S11(max(idex)),'ok')

    grid on;
    axis([0 360 0 1])
    title(strcat(DeviceName,': S11'));

    saveas(gcf,strcat('Polar_S11','-', DeviceName),'png');
    saveas(gcf,strcat('Polar_S11','-', DeviceName),'fig');

   
    %% Impedance
    figure(5); clf;
    Zin=(1+S11)./(1-S11).*Z0; % Input impedance

    plot(f(idex)/10^6, real(Zin(idex)),'k')
    hold on;
    plot(f(idex)/10^6, imag(Zin(idex)),'--k');

    legend('R_{in}','X_{in}');
    xlabel('Frequency (MHz)');
    ylabel('R_{in} and X_{in} (\Omega)')
    grid on;
    title(strcat(DeviceName,': Input Impedance (from S11)'));

    saveas(gcf,strcat('Input Impedance','-', DeviceName),'png');
    saveas(gcf,strcat('Input Impedance','-', DeviceName),'fig');

    %%  Create and store the figures: S21
    if Portas==2,    % Medidas two-port two path
        % S21 in logmag units
        figure(6); clf;
        plot(f(idex)/1E6,20.*log10(abs(S21(idex))),'k')
        xlabel('Frequency (MHz)');
        ylabel('S21 (Log. Magnitude) (dB)');
        grid on;
        title(strcat(DeviceName,': S21'));

        saveas(gcf,strcat('LogMagS21','-', DeviceName),'png');
        saveas(gcf,strcat('LogMagS21','-', DeviceName),'fig');

        %% S21 in polar
        figure(7); clf;
        polarplot(S21(idex),'k')
        hold on;
        polarplot(S21(min(idex)),'ok')
        polarplot(S21(max(idex)),'*k')

        legend('S_{21}','f_{min}','f_{max}');
        grid on;
        axis([0 360 0 1])
        title(strcat(DeviceName,': S21'));

        saveas(gcf,strcat('Polar_S21','-', DeviceName),'png');
        saveas(gcf,strcat('Polar_S21','-', DeviceName),'fig');

%% S21: ângulo em função da frequência
    figure(4); clf;
    plot(f(idex)/1E6, 180/pi*angle(S21(idex)),'k')
    hold on;
        
    grid on;
    ylim([-180 180]);
    title(strcat(DeviceName,': S21-Phase'));
    xlabel('Frequency (MHz)');
    ylabel('\angle (deg)')

    saveas(gcf,strcat('Angle_S21','-', DeviceName),'png');
    saveas(gcf,strcat('Angle_S21','-', DeviceName),'fig');    

    end
end
end