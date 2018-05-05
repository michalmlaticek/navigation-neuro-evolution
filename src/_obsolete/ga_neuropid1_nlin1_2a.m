% SGA / NEURO PID, 5-3-1, 3 skryte neurony, vstupy: ie,e,y,dy,ddy
% ML R2013a
%==========================================================================

clear all;
close all;

% matlabpool('open','AttachedFiles',{[pwd '\']})

% tic;

Ngen=15;  % pocet migracnych cyklov  ****************
lpop=100; %% 50

Ts=0.001;    % vzorkovanie
cas=10;     % cas simulacie

M=1;  
lstring=15;
Space=[-M*ones(1,lstring); M*ones(1,lstring)];  %pracovny priestor  
Sigma=Space(2,:)/50;%pracovny priestor mutacie

pb=[25 7 0.2 1];  % pracovny bod reg. obvodu [r1,r2,k1,k2]

%-----------------------------------------------------
% POPULATION INITIALIZATION

Pop=zeros(lpop,lstring);
% Pop=genrpop(lpop, Space);
% Pop(1,:)=[5 10 0];

load ga_neuropid1_nlin1_2a
Pop(1,:)=Pop0(1,:);   % inicializacia 
    
%--------------------------------------------------------
% MAIN CYCLE

for g=1:Ngen   % cyklus
    g
    [Pop, Fit, bestOne]=generacia_neuropid1_2(Pop, Space, Sigma, lpop, pb);
    gfit(g)=min(Fit);
end

figure(1); 
hold on;
plot(gfit,'r');

W1(1,1)=bestOne(1);   
W1(2,1)=bestOne(2);
W1(3,1)=bestOne(3);
W1(1,2)=bestOne(4);
W1(2,2)=bestOne(5);
W1(3,2)=bestOne(6);   
W1(1,3)=bestOne(7);
W1(2,3)=bestOne(8);
W1(3,3)=bestOne(9);
W1(1,4)=bestOne(10);
W1(2,4)=bestOne(11);   
W1(3,4)=bestOne(12);
W1(1,5)=bestOne(13);
W1(2,5)=bestOne(14);
W1(3,5)=bestOne(15);
W2=ones(1,3)*100000;

assignin('base','W1',W1);
assignin('base','W2',W2);
assignin('base','Ts',Ts);
assignin('base','cas',cas);
SimOut = sim('neuropid1_nlin1_2a', 'ReturnWorkspaceOutputs', 'on');
yy1=get(SimOut,'y1');
ww1=get(SimOut,'w1');
tt=get(SimOut,'t');

figure(2); hold on;
plot(tt,ww1,'k',tt,yy1,'m');

Pop0=Pop;
save ga_neuropid1_nlin1_2a Pop0 W1 W2

% toc

% matlabpool close