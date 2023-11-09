function PlotMultiArduinoVoltage(pinstoread, numsamples)         %PlotMultiArduinoVoltage(["A1" "A2" "A3"], 25)
    numpins = numel(pinstoread);
    myarduino = arduino;               %connect to Arduino
    % loop over the pins to configure them as analogue input
    for pinindex = 1:numpins
        myarduino.configurePin(pinstoread(pinindex), "AnalogInput");
    end
    voltages = zeros(numsamples, numpins);  %create an array to hold numsamples x number of pins samples
    %??  myarduino.configurePin(pintoread,"AnalogInput");   % configure selected pin as analog input
    %??  voltage = zero(1, numsamples);            % allocate memory for storing the voltage of the pin, as a N element row vector
    hbar = waitbar(0, "reading voltage pin of" + strjoin(pinstoread,", "));
    for sampleidx = 1:numsamples
        for pinindex = 1:numpins
            voltages(sampleidx, pinindex) = myarduino.readVoltage(pinstoread(pinindex));   %store voltage of current pin pinstoread(pinindex) at the 
        end
        %?? voltages(sampleidx) = myarduino.readVoltage(pinstoread);  %read the voltage and store in the array
        waitbar(sampleidx/numsamples, hbar);
    end
    close(hbar);
    figure;
    plot(voltages);
    ylabel("Voltage of pin(s) (V)");
    xlabel("sample number");
    legend(pinstoread);
end
