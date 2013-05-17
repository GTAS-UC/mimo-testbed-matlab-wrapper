function detect_register_changes(node,board)

% TODO: choose board

regs=hex2dec('1000'):4:hex2dec('1200');
regs_content1=nan(size(regs));
regs_content2=nan(size(regs));

%Before
for kk=1:length(regs)
    reg=regs(kk);
    regs_content1(kk)=eval(dac_ReadFPGAReg(node,reg));
   
end

disp('Paused...');
pause;

%After
for kk=1:length(regs)
    reg=regs(kk);
    regs_content2(kk)=eval(dac_ReadFPGAReg(node,reg));
end

df=(regs_content2~=regs_content1);

dec2hex(regs(df),4)