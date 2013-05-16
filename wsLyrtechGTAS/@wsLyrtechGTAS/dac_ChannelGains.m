function dac_ChannelGainsResult = dac_ChannelGains(obj,Gains)

dac_ChannelGainsResult=dac_ChannelGains(obj.wsLyrtech,b64e(Gains(:).')); %using inherited method