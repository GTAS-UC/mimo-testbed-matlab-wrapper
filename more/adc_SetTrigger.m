function status = adc_SetTrigger(node,source)
%ADC_SETTRIGGER Choose trigger source:
%
%    Source:
%        1-16: Trigger signal expected in the corresponding ADC channel
%        (not implemented)
%         0: Manual trigger (default behaviour)
%        -1: External trigger
%        
%
%    Polarity:
%        'rise': Trigger detected on rising edge
%        'fall': Trigger detected on falling edge

%% Configure acquisition and trigger control register (0x001C)
% Enable the digital trigger mechanism
TRIGGER_CONTROL=hex2dec('001C');

reg_value=dec2bin(eval(adc_ReadFPGAReg(node,TRIGGER_CONTROL)),32);
switch source
    case 0 %Manual
        trigger_enable='0';
    case -1 %External
        trigger_enable='1';
end

reg_value(end-3)=trigger_enable;

status1=dec2bin(eval(adc_WriteFPGAReg(node,TRIGGER_CONTROL,bin2dec(reg_value))),32);

%% Configure register 0x1010 (recording module memory space)
TRIGGER_CONF=hex2dec('1000')+hex2dec('10');

reg_value=dec2bin(eval(adc_ReadFPGAReg(node,TRIGGER_CONF)),32);

trigger_select='0000';
trigger_control_run='0';
switch source
    case 0
        trigger_control_src='00';
    case -1
        trigger_control_src='10';
%     case {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
%         trigger_control_src='01';
%         trigger_select=dec2bin(source-1,4);
    otherwise
        disp('Invalid trigger source');
end

% switch lower(polarity)
%     case 'rise'
%         trigger_control_pol='1';
%     case 'fall'
%         trigger_control_pol='0';
%     otherwise
%         trigger_control_pol=old_reg_value(end-16);
% end

% reg_value(end-16)=trigger_control_pol;
reg_value(end-17)=trigger_control_run;
reg_value(end-[20 19])=trigger_control_src;
reg_value(end-[3 2 1 0])=trigger_select;
status2=dec2bin(eval(adc_WriteFPGAReg(node,TRIGGER_CONF,bin2dec(reg_value))),32);

%ToDo: Set trigger level
% TRIGGER_LEVEL=hex2dec('1000')+hex2dec('14');
% adc_WriteFPGAReg(node,TRIGGER_LEVEL,0);
% level=dec2bin(eval(adc_ReadFPGAReg(node,TRIGGER_LEVEL)),32);
% level(17:end)

%% Return registers' status
status=[status1;status2];
end

