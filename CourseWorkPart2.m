[FullTrackData,Fs] = audioread('C:\Users\EISSA\Downloads\Tahayya.mp3'); %Read the music file into "FullTrackData" and sample rate into Fs
%Note that audioread will read various types of music file, eg mp3, wav etc.
%Look it up in the help files

Fs %Print Fs to the command window

disp('Shortening track if needed')
if(size(FullTrackData,1)>700000)
    Data(:,:) = FullTrackData(1:700000,:); %Shorten track to about 15 s
else
    Data = FullTrackData;
end

GroupSize = 50000;
GroupedSamples = zeros(GroupSize,2); %Create a matrix 50000 by 2 and fill it all with zeros
Datal = zeros(700000, 2); %Create a matrix 700000 by 2 and fill it all with zeros
Datal = Data; %Fill the matrix (Datal) with Data
for n = 1 : 14
   if (n >= 2)
       i = ((n-1)*GroupSize)+1; %To make the different between i and n*GroupSize 50000
   else
       i = n;
   end
    GroupedSamples( : , :) = Datal( i : n*GroupSize , :); %Fill the GroupedSamples with 50000 rows from Datal
    pause(1.0416666667) %Wait 1.0416666667 seconds to allow the music to play to the end
   if rem(size(GroupedSamples,1),GroupSize) == 0 %check if the remaining is equal to 0
      [b,a] = sos2tf(SOS,G); %Convert the SOS and G to coefficient value for b and a
      IIRlowpass = filter(b, a, GroupedSamples); %Filter the RAW music through IIR high pass
      sound(IIRlowpass,Fs) %Play the music at sample rate Fs
   end
    GroupedSamples = zeros(GroupSize,2); %Reset the matrix (GroupedSamples) to all zeros
end
