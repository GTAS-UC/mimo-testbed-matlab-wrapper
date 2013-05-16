function dac_SDRAMWriteResult= dac_SDRAMWrite(obj,Data)

try
    aux=b64e_java(Data(:).');
catch er
    aux=b64e(Data(:).');
end

dac_SDRAMWriteResult=dac_SDRAMWrite(obj.wsLyrtech,aux); %using inherited method