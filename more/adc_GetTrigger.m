function status = adc_GetTrigger(node)

%Read trigger status
TRIGGER_CONF=hex2dec('1000')+hex2dec('10');
trigger_status=dec2bin(eval(adc_ReadFPGAReg(node,TRIGGER_CONF+3)),4);

trigger_status=bin2dec(trigger_status(end-[3:-1:0]));

strs={'IDLE','ARMED','WAITING','STORING','READY','PRE-READY',...
    'DATA SELECT ERROR','TRIGGER SELECT ERROR','STORAGE OVERRUN ERROR',...
    'PACKING OVERRUN ERROR','DATA OVERRUN ERROR'};

status=strs{trigger_status+1};
