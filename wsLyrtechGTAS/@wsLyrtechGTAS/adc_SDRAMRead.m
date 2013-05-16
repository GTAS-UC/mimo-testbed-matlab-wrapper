function adc_SDRAMReadResult= adc_SDRAMRead(obj,SamplesPerChannel)

adc_SDRAMReadResult=double(b64d(adc_SDRAMRead(obj.wsLyrtech,SamplesPerChannel))); %using inherited method

adc_SDRAMReadResult=reshape(adc_SDRAMReadResult,length(adc_SDRAMReadResult)/SamplesPerChannel,SamplesPerChannel);