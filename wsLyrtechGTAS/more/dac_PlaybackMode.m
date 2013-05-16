function success = dac_PlaybackMode(node,mode_str)
%DAC_PLAYBACKMODE Configure DAC playback mode: 'single-shot' or 'continuous'
%   Detailed explanation goes here



PLAYBACK_CONTROL=hex2dec('1032');

%Read RFFE_OPERATION_MODE
opmode=dec2bin(eval(dac_ReadFPGAReg(node,PLAYBACK_CONTROL)),3);

switch lower(mode_str)
    case 'single-shot'
        c = '0';
        opmode(end-2) = c;
        dac_WriteFPGAReg(node,PLAYBACK_CONTROL,bin2dec(opmode));
    case 'continuous'
        c = '1';
        opmode(end-2) = c;
        dac_WriteFPGAReg(node,PLAYBACK_CONTROL,bin2dec(opmode));
    otherwise
        error('Unknown playback mode')
end

%Verify that the desired value has been set
output=dec2bin(eval(dac_ReadFPGAReg(node,PLAYBACK_CONTROL)),3);
output=output(end-2);

if output==c
    success=true;
else
    success=false;
end
end

