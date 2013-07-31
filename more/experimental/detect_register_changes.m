function detect_register_changes(node,board)

regs=[hex2dec('0000'):4:hex2dec('0020')  hex2dec('1010'):4:hex2dec('101C')];
regs_content1=nan(size(regs));
regs_content2=nan(size(regs));

%Before
for kk=1:length(regs)
    reg=regs(kk);
    if strcmp(board,'adc')
        regs_content1(kk)=eval(adc_ReadFPGAReg(node,reg));
    else
        regs_content1(kk)=eval(dac_ReadFPGAReg(node,reg));
    end
end

disp('Paused...');
pause;

%After
for kk=1:length(regs)
    reg=regs(kk);
    if strcmp(board,'adc')
        regs_content2(kk)=eval(adc_ReadFPGAReg(node,reg));
    else
        regs_content2(kk)=eval(dac_ReadFPGAReg(node,reg));
    end
end

idxs=find(regs_content2~=regs_content1);

disp('Modified registers:')
fprintf('Register(hex) Old value(bin) New value (bin) Diff (bin)\n')
for kk=1:size(idxs,1) 
    bin_old=dec2bin(regs_content1(idxs(kk)));
    bin_new=dec2bin(regs_content2(idxs(kk)));
    fprintf('%s %s %s %s\n',dec2hex(regs(idxs(kk)),4),bin_old,bin_new, abs(bin_old-bin_new));
end