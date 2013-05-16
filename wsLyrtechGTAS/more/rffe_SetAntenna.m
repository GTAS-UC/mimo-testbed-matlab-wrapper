function rffe_SetAntenna(node,antenna)

switch antenna
    case {'A',0}
        antenna_bin=0; % antenna_bin=0 Antenna A
    case {'B',1}
        antenna_bin=1; % antenna_bin=1 Antenna B
    otherwise
        error('Invalid antenna identifier: %s. Valid identifiers are ''A'' or ''B''.',antenna);
end

old_value=dec2bin(eval(adc_ReadFPGAReg(node,hex2dec('123C'))),3);
old_value(3-1)= num2str(~antenna_bin);
adc_WriteFPGAReg(node,hex2dec('123C'),bin2dec(old_value));



