function rffe_MODE(node,transceiver,mode_str)


RFFE_OPERATION_MODEX=hex2dec('1244')+4*(transceiver-1);
%Read RFFE_OPERATION_MODE
opmode=dec2bin(eval(adc_ReadFPGAReg(node,RFFE_OPERATION_MODEX)),10);

%write RFFE_OPERATION_MODE
en='0';
opmode(10-9)=en;
dec2bin(eval(adc_WriteFPGAReg(node,RFFE_OPERATION_MODEX,bin2dec(opmode))),10);

%Apply power amplifier enable
switch upper(mode_str)
    case 'SPI_RESET'
        mode=dec2bin(hex2dec('40'),7);
    case 'SHUTDOWN'
        mode=dec2bin(hex2dec('20'),7);
    case 'STANDBY'
        mode=dec2bin(hex2dec('10'),7);
    case 'RX'
        mode=dec2bin(hex2dec('08'),7);
    case 'TX'
        mode=dec2bin(hex2dec('04'),7);
    case 'RX CAL'
        mode=dec2bin(hex2dec('02'),7);
    case 'TX CAL'
        mode=dec2bin(hex2dec('01'),7);
    otherwise
        mode='';
end

if isempty(mode)
    return;
end

opmode(10-[6:-1:0])=mode;
%Latch on 0 to 1 transition of EN bit
en='1';
opmode(10-9)=en;
dec2bin(eval(adc_WriteFPGAReg(node,RFFE_OPERATION_MODEX,bin2dec(opmode))),10);

en='0';
opmode(10-9)=en;
dec2bin(eval(adc_WriteFPGAReg(node,RFFE_OPERATION_MODEX,bin2dec(opmode))),10);