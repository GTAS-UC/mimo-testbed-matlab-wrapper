function div_ratio_tests
clc;
clear; close all;

f_RF_TX=5600; %MHz
f_RF_RX=5610; %MHz

% f_RF_TX=2484; %MHz
% f_RF_RX=2494; %MHz

%Compute f_IF
theoretical_f_IF=f_RF_RX-f_RF_TX;

actual_f_RF_TX = actual_RF_freq(f_RF_TX);
actual_f_RF_RX = actual_RF_freq(f_RF_RX);

practical_f_IF=actual_f_RF_RX-actual_f_RF_TX;


% Print actual RF frequency
fprintf('RF freq. TX: %.2f Hz (Desired: %.2f Hz)\n',actual_f_RF_TX*1e6,f_RF_TX*1e6);
fprintf('RF freq. RX: %.2f Hz (Desired: %.2f Hz)\n',actual_f_RF_RX*1e6,f_RF_RX*1e6);
fprintf('Practical IF freq.: %.2f Hz (Theoretical: %.2f Hz)\n',practical_f_IF*1e6,theoretical_f_IF*1e6);


    function actual_RF_freq_MHz = actual_RF_freq(desired_RF_freq_MHz)
        %% Compute constant depending on frequency band
        
        if desired_RF_freq_MHz>=2400 && desired_RF_freq_MHz<=2500
            c = 4/3;
        elseif desired_RF_freq_MHz>=5000 && desired_RF_freq_MHz<=5900
            c = 4/5;
        else
            error('This frequency band is not allowed!')
        end
        
        %% Obtain register values from f_RF
        Div=desired_RF_freq_MHz*c/20;
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
        
        actual_RF_freq_MHz=(Int_div+Fr_div)*20/c;
        
    end

end