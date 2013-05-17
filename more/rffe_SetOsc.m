function rffe_SetOsc(node,src)
% Configure RFFE reference clock source: 'external' or 'internal'

%We use adc_WriteFPGAReg to send commands to the RFFE because it is always
%controlled by the ADC board
switch lower(src)
    case 'external'
        adc_WriteFPGAReg(node,hex2dec('123C'),hex2dec('2'));%External clock
    case 'internal'
        adc_WriteFPGAReg(node,hex2dec('123C'),hex2dec('3'));%Internal clock
    otherwise
        error('Unknown reference clock source')
end

%Check if RFFE is locked
islocked = rffe_LOCKED(node);

if ~any(logical(islocked-'0'))
    warning('None of the transceivers is locked. Are they switched off? Is the external reference connected to the RFFE?')
end