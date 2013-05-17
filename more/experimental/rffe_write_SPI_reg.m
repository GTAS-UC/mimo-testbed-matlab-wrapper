
function write_SPI_reg(node,transceiver,reg,value)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Writes one of the following registers to the RFFE SPI port
%
%   node : which node controls the RFFE -> transmitter(tx) / receiver node(rx)
%   transceiver : transceiver number (1:4)
%   reg : register number
%
%           0 -> RFFE_REGISTER0
%           1 -> RFFE_REGISTER1
%           2 -> RFFE_STANDBY
%           3 -> RFFE_I_D_RATIO
%           4 -> RFFE_F_D_RATIO
%           5 -> RFFE_BAND_SELECT_PLL
%           6 -> RFFE_CALIBRATION
%           7 -> RFFE_LOWPASS_FILTER
%           8 -> RFFE_RX_CONTROL_RSSI
%           9 -> RFFE_TX_LINEARITY_BB_GAIN
%           10 -> RFFE_PA_BIAS_DAC
%           11 -> RFFE_RX_GAIN
%           12 -> TX_VGA_GAIN
%
%   value : register value (Hexadecimal) 
%
%   v1.0 Jan, 11, 2011
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BASE_ADDRESS = hex2dec('1200');
reg_addr = dec2hex(BASE_ADDRESS + 4*reg,4);

value_adress_channel = dec2bin(transceiver-1,16);
value_adress_channel_hex = dec2hex(bin2dec(value_adress_channel));
value_adress_reg(length(value_adress_channel)-2-reg) = '1';
value_adress_reg_on = dec2hex(bin2dec(value_adress_reg),4);

if strcmp(node,'tx')
    % Register
    dac_WriteFPGAReg(node,reg_addr,value);
    % Address Register (Write the register to the RFFE SPI port)
    dac_WriteFPGAReg(node,hex2dec('1234'),value_adress_channel_hex);
    dac_WriteFPGAReg(node,hex2dec('1234'),value_adress_reg_on);
else
    % Register
    adc_WriteFPGAReg(node,reg_addr,value);
    % Address Register (Write the register to the RFFE SPI port)
    adc_WriteFPGAReg(node,hex2dec('1234'),value_adress_channel_hex);
    adc_WriteFPGAReg(node,hex2dec('1234'),value_adress_reg_on);  
end
