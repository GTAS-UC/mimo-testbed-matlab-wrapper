function rffe_RXHPnarrow(node,transceiver)

%Select transceiver
% rffe_address_reg=dec2bin(eval(adc_ReadFPGAReg(node,hex2dec('1234'))),32);
% rffe_address_reg(32-[1 0])=dec2bin((transceiver-1),2);
% adc_WriteFPGAReg(node,hex2dec('1234'),rffe_address_reg);

RFFE_OPERATION_MODEX=hex2dec('1244')+4*(transceiver-1);
%Read RFFE_OPERATION_MODE
opmode=dec2bin(eval(adc_ReadFPGAReg(node,RFFE_OPERATION_MODEX)),10);

%write RFFE_OPERATION_MODE
en='0';
opmode(10-9)=en;
dec2bin(eval(adc_WriteFPGAReg(node,RFFE_OPERATION_MODEX,bin2dec(opmode))),10);

%Apply power amplifier enable
rxhpen='0'; %'0' cutoff freq 100Hz, '1' cutoff freq 600KHz
opmode(10-7)=rxhpen;
%Latch on 0 to 1 transition of EN bit
en='1';
opmode(10-9)=en;
dec2bin(eval(adc_WriteFPGAReg(node,RFFE_OPERATION_MODEX,bin2dec(opmode))),10);

en='0';
opmode(10-9)=en;
dec2bin(eval(adc_WriteFPGAReg(node,RFFE_OPERATION_MODEX,bin2dec(opmode))),10);