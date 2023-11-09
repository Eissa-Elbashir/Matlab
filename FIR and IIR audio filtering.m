
[FullTrackData,Fs]=audioread('C:\Users\EISSA\Downloads\Tahayya.mp3'); %Read the music file into "FullTrackData" and sample rate into Fs
%Note that audioread will read various types of music file, eg mp3, wav etc.
%Look it up in the help files

Fs %Print Fs to the command window

disp('Shortening track if needed')
if(size(FullTrackData,1)>700000)
    Data(:,:)=FullTrackData(1:700000,:); %Shorten track to about 15 s
else
    Data=FullTrackData;
end

[b,a]=sos2tf(SOS,G); %Convert the SOS and G to coefficient value for b and a

FIRlowpass=filter(Num,1,Data); %Filter the RAW music through FIR low pass 
IIRhighpass=filter(b,a,Data); %Filter the RAW music through IIR high pass

sound(Data,Fs); %Play the music at sample rate Fs
pause(15) %Wait 15 seconds to allow the music to play to the end
 
sound(FIRlowpass,Fs); %Play the music at sample rate Fs
pause(15) %Wait 15 seconds to allow the music to play to the end

sound(IIRhighpass,Fs); %Play the music at sample rate Fs
pause(15) %Wait 15 seconds to allow the music to play to the end

DataFFT=abs(fft(Data)); %Convert the signal Data from time domain to frequency domain
FIRlowpassFFT=abs(fft(FIRlowpass)); %Convert the signal FIRlowpass from time domain to frequency domain
IIRhighpassFFT=abs(fft(IIRhighpass)); %Convert the signal IIRhighpass from time domain to frequency domain

figure(1)
plot(Data) 

figure(2)
plot(FIRlowpass) 

figure(3)
plot(IIRhighpass) 

figure(4)
plot(DataFFT) 

figure(5)
plot(FIRlowpassFFT) 

figure(6)
plot(IIRhighpassFFT)
