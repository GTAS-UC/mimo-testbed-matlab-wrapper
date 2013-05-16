clc;
clear; close all;

f_RF=5610.000000;

%% Obtain register values from f_RF
Div=f_RF*4/5/20;
Int_div=fix(Div);
Fr_div=Div-fix(Div);
Fr_div_aux=round(Fr_div*2^16);

% Print register values
Int_div_bit=dec2bin(Int_div,8)
Fr_div_MSB_hex=dec2hex(bitshift(Fr_div_aux,-2),4)
Fr_div_LSB_bit=dec2bin(bitand(Fr_div_aux,3),2)

%% Obtain f_RF from register values
Fr_div_LSB=bin2dec(Fr_div_LSB_bit);
Fr_div_MSB=hex2dec(Fr_div_MSB_hex);
Int_div=bin2dec(Int_div_bit);
Fr_div=(Fr_div_MSB*2^2+ Fr_div_LSB)*2^(-16);

actual_f_RF=(Int_div+Fr_div)*20*5/4;

% Print actual RF frequency
fprintf('Desired RF freq.: %.2f Hz\n',f_RF*1e6);
fprintf('Actual  RF freq.: %.2f Hz\n',actual_f_RF*1e6);