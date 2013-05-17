function rffe_PABS_5GHz(node)
old_value=dec2bin(eval(adc_ReadFPGAReg(node,hex2dec('123C'))),3);
old_value(3-2)='0';
adc_WriteFPGAReg(node,hex2dec('123C'),bin2dec(old_value));

