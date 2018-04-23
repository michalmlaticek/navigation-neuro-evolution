% jedna generacia SGA, nlin1

function[Pop, Fit, bestOne]=generacia_neuropid1_2(Pop, Space, Sigma, lpop, pb)

Ts=0.001;
cas=10;

r1=pb(1); r2=pb(2); k1=pb(3); k2=pb(4);  % pracovny bod

for k=1:lpop
    
W1(1,1)=Pop(k,1);   
W1(2,1)=Pop(k,2);
W1(3,1)=Pop(k,3);
W1(1,2)=Pop(k,4);
W1(2,2)=Pop(k,5);
W1(3,2)=Pop(k,6);   
W1(1,3)=Pop(k,7);
W1(2,3)=Pop(k,8);
W1(3,3)=Pop(k,9);
W1(1,4)=Pop(k,10);
W1(2,4)=Pop(k,11);   
W1(3,4)=Pop(k,12);
W1(1,5)=Pop(k,13);
W1(2,5)=Pop(k,14);
W1(3,5)=Pop(k,15);
W2=ones(1,3)*100000;
    
    try     % simulacia
        assignin('base','W1',W1);
        assignin('base','W2',W2);
        assignin('base','r1',r1);
        assignin('base','r2',r2);
        assignin('base','k1',k1);
        assignin('base','k2',k2);
        assignin('base','Ts',Ts);
        assignin('base','cas',cas);
        SimOut = sim('neuropid1_nlin1_2a', 'ReturnWorkspaceOutputs', 'on');
        ee1=get(SimOut,'e1');
        dyy1=get(SimOut,'dy1');
        tt=get(SimOut,'t');
        Fit(k)=sum(abs(ee1))+0.1*sum(abs(dyy1));
    catch
        Fit(k)=1e6;
    end
end

Best=selbest(Pop,Fit,[1,1,1,1,1]);
Old=seltourn(Pop,Fit,15);
Work1=selsus(Pop,Fit,30);
Work2=seltourn(Pop,Fit,50);
Work1=crossov(Work1,1,0);
Work2=muta(Work2,0.1,Sigma,Space);
Work2=mutx(Work2,0.1,Space);
Pop=[Best;Old;Work1;Work2];

bestOne=Best(1,:);