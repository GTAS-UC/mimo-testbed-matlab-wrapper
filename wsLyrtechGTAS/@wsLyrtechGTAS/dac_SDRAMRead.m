function dac_SDRAMReadResult= dac_SDRAMRead(obj,SamplesPerChannel)

r=dac_SDRAMRead(obj.wsLyrtech,SamplesPerChannel);
try
   aux=b64d_java(r);
catch er
   aux=b64d(r);
end
dac_SDRAMReadResult=double(aux); %using inherited method

dac_SDRAMReadResult=reshape(dac_SDRAMReadResult,length(dac_SDRAMReadResult)/SamplesPerChannel,SamplesPerChannel);