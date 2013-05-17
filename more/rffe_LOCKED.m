function islocked = rffe_LOCKED(node)

islocked=0;
for transceiver=1:4
adc_WriteFPGAReg(node,hex2dec('1234'),hex2dec('40000000')+transceiver-1);
islocked = bitor(islocked,eval(adc_ReadFPGAReg(node,hex2dec('1240'))));
end
islocked=fliplr(dec2bin(islocked,4));