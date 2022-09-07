%=============This version of code is working for 2 drivers=======%

function [Vout, stack_potential]=MQCAWireCalCharge(stack_potential,stack_mol, CK, settings)

    ConvChk = 0;
    step = size(stack_potential,1);
    Conv=zeros(stack_mol.num,1);

    stack_potential = [stack_potential; zeros(1,stack_mol.num)];

    while(ConvChk==0) % Using WHILE to judge if the molecules are convergent or not, much more safe!!    
        for ii=1:stack_mol.num
            for jj=1:stack_mol.num
                if (ii==jj)
                    continue;
                else
                    V10 = stack_potential(step, ii);
                    pre_V = sum(stack_potential(1:step-1,ii));
                    V_effect = CalPotential(V10,pre_V,stack_mol.stack(ii),stack_mol.stack(jj), CK);
                    if(jj<ii)
                         stack_potential(step+1, jj) = stack_potential(step+1, jj) + V_effect;
                    else
                         stack_potential(step, jj) = stack_potential(step, jj) + V_effect;
                    end
                end
            end
            
     	if (ii==stack_mol.num)
          	step = step + 1
          	stack_potential = [stack_potential; zeros(1,stack_mol.num)];
        end
        %%================ CONVERGENCY ===================================           
      	MolCnt = 1;
       	Conv=zeros(stack_mol.num,1);
        

        if step > 3 
            while(MolCnt<=stack_mol.num)
                if (step < 0.70*settings.max_step)
                    if(MolCnt<stack_mol.num)
%                         if abs(abs(stack_potential(step-1, MolCnt))-abs((stack_potential(step-2, MolCnt)))) < 0.05
                        if abs(abs(stack_potential(step-1, MolCnt))-abs((stack_potential(step-2, MolCnt)))) < settings.conv_threshold_HP
                            Conv(MolCnt,1)=1;
                        end
                    elseif(MolCnt==stack_mol.num)
%                         if abs(abs(stack_potential(step-2, MolCnt))-abs((stack_potential(step-3, MolCnt))))  < 0.05
                            if abs(abs(stack_potential(step-2, MolCnt))-abs((stack_potential(step-3, MolCnt))))  < settings.conv_threshold_HP
                            Conv(MolCnt,1)=1;
                        end     
                    end 
                else
                    if(MolCnt<stack_mol.num) %low precision
                        if abs(abs(stack_potential(step-1, MolCnt))-abs((stack_potential(step-2, MolCnt)))) < settings.conv_threshold_LP
    %                     if abs(abs(stack_potential(step-1, MolCnt))-abs((stack_potential(step-2, MolCnt)))) < 0.00005
                            Conv(MolCnt,1)=1;
                        end
                    elseif(MolCnt==stack_mol.num)
                        if abs(abs(stack_potential(step-2, MolCnt))-abs((stack_potential(step-3, MolCnt))))  < settings.conv_threshold_LP
    %                         if abs(abs(stack_potential(step-2, MolCnt))-abs((stack_potential(step-3, MolCnt))))  < 0.00005
                            Conv(MolCnt,1)=1;
                        end     
                    end 
                disp('Warning low precision');
                end
                
                                
                MolCnt=MolCnt+1; 
                ConvChk=prod(Conv);
            end
        end 
%         end
        
        %%% If Convergency is not reached
        if step > settings.max_step
            errordlg('Out from rage step. The convergence is not reach. Stop the simulation')
            pause
        end
  
        end

        res=zeros(stack_mol.num,1);
       	for ii=1:stack_mol.num
           	res(ii)=sum(stack_potential(:,ii));
        end
        
        %% OUTPUT
        Vout=res;
end