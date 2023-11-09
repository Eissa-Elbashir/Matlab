function PlotArduinoVoltagesContinuous_withClass(pinstoread, numsamples)   %PlotArduinoVoltagesContinuous_withClass(["A1" "A2" "A3"], 25)
    %PLOTARDUINOVOLTAGESCONTINUOUS continuously plot the voltage of selected Arduino pins on a rolling display of fixed width
    %this function connects to an arduino board then continuously read the voltages on the pins specified by pinstoread
    %then update the plot of a new figure.
    %The function runs continuously until the figure is closed
    %   pinstoread vector of analog arduino pins (must start with "A" and be followed by digits). Defaults to "A0".
    %   numsamples number of samples to plot (per pin). Must be positive scalar integer. Defaults to 100.
    arguments
        pinstoread (1, :) string {mustBeValidPin} = "A0"  %this could also work without a size restriction
        numsamples (1, 1) double {mustBeInteger, mustBePositive} = 100
    end
    numpins = numel(pinstoread);  %create a variable to hold the number of pins to make it easier to reuse
    myarduino = arduino;   %connect to arduino
    %loop over the pins to configure them as analogue input
    for pinindex = 1:numpins
        myarduino.configurePin(pinstoread(pinindex), "AnalogInput");
    end
    voltageBuffer = FixedSizeCircularBuffer(numsamples, numpins); %create an array to hold numsamples x number of pins samples.
    newsamples = zeros(1, numpins);   %create an array to store the new samples. A row vector.
    hfig = figure;  %create new figure for plotting
    hlines = plot(voltageBuffer.BufferContent);  %creates line plots for the voltage. Since voltages is NaN to start with, nothing is plotted but each line has the correct length.
    %hlines.Ydata will be updated in the loop below to avoid replotting everything. Since the existing plot will be reused we can set the limits, etc. once
    xlim([0. numsamples]);
    ylim([0, 5]);
    legend(pinstoread);
    xlabel("Sample number");
    ylabel("Voltage");
    numticks = numel(xticklabels);  %grab the number of tick labels so we can update them as the plot scrolls
    startsample = 1; %variable to keep track of the sample index in order to update the tick labels.
    while isvalid(hfig)  %loop runs as long as the figure exists. if the user closes the figure, the function stops
        %read the new value of each pin using a loop
        for pinindex = 1:numpins
            newsamples(pinindex) = myarduino.readVoltage(pinstoread(pinindex)); %store voltage of current pin pinstoread(pinindex) at the correct location in the voltage array
        end
        voltageBuffer = voltageBuffer.ShiftAndAdd(newsamples); %use our circular buffer function to update the voltages
        %now update the line plots
        for pinindex =  1:numpins
            hlines(pinindex).YData = voltageBuffer.BufferContent(:, pinindex);
        end
        %Note: a way to do the above without a loop:
        %updatedplot = num2cell(voltages, 1); %split columns of voltages into cell array
        %[hlines.YData] = updatedplot{:}; %use comma separated list behaviour of cell arrays to distribute to multiple elements
        xticklabels(linspace(startsample-numsamples, startsample, numticks)); %update tick labels
        drawnow;  %force redraw
        startsample = startsample + 1;
    end
end

function mustBeValidPin(pins)
    assert(all(matches(pins, "A" + digitsPattern)), "Invalid pin specified");
end