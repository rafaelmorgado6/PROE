clear,clc,close all

Vg=2;           %Volts gerador   
Zg=50;          %Impedancia do gerador
Z0=Zg;          %Impedancia carateristica
l=1.25;         %comprimento da linha
f=300e6;        %frequencia (Hz)
alpha=0;        %constante de atenuação
ZL=100;         %useer input (can be complex)

%% Problem solving steps
% 1.
lameda=300e6/f;         %lameda= 300/f(em MHz)-> 300e6/f(em Hz) (SLIDE 6)
T=1/f;                  %periodo
pl=(ZL-Z0)/(ZL+Z0);     %coeficiente de refleção   (SLIDE 57)
beta=2*pi/lameda;       %constante de fase     (SLIDE 33)  
gama=alpha+1i*beta;     %constante de propagaçao    (SLIDE 33)
w=2*pi*f;               %frequência angular 

x=linspace(0,l,1000);   %vetor com 1000 pontos e com distancia de 1.25

% 2.
% a)
Vi=Vg/2*exp(-gama*x);   %Tensão Incidente  (SLIDE 60)
Ii=Vi/Z0;               %Corrente Incidente  (SLIDE 60)

% b)
Vr=Vg/2*exp(-2*gama*l)*pl*exp(gama*x);  %Tensão refletida  (SLIDE 60)
Ir=-Vr/Z0;                               %Corrente Refletida  (SLIDE 60)

% 3.
Vstand=abs(Vi + Vr);  %Vetor de amplitude da tensão da onda estacionária

figure(1)
plot(x,Vstand); %Gráfico
grid on
title('Tensão da onda estacionária')
xlabel('Comprimento da linha (m)')
ylabel('Voltage (V)')

VSWRc=(1+abs(pl))/(1-abs(pl)); %Usando calculos 
VSWRg=max(Vstand)/min(Vstand); %Usando os gráficos

% 4.
Istand = abs(Ii + Ir);   %Vetor de amplitude da corrente da onda estacionária

hold on         %manter o grafico anterior
plot(x,50*Istand,'r')
title('Tensão e Corrente da onda estacionária')
ylabel('Voltage (V) / Corrente (A)')
legend('Vstand','Istand')
hold off

% 5.
figure(2)
plot(x,Vstand,'b',x,-Vstand,'r',x,50*Istand,'c',x,50*(-Istand),'m')
grid on
title('Tensão e Corrente da onda estacionária e seus simétricos')
xlabel('Comprimento da linha (m)')
ylabel('Voltage (V) / Corrente (A)')
legend('Vstand','-Vstand','Istand','-Istand')

% 6.
Tstep = T/32;
t = 0;
figure
plot(x, Vstand, x, -Vstand,x, 50*Istand, x, 50*(-Istand));
grid on
ylim([-2 2])
hold on
for i = 1:160
    hv = plot(x,real((Vi+Vr).*exp(1i*w*t)),'b');
    hi = plot(x,real(25*(Ii-Ir).*exp(1i*w*t)),'r');
    pause(0.25);
    delete(hv); 
    delete(hi);
    t = t+Tstep;
end

% 7.
 
% 8.
figure(4)
px=Vr./Vi;     %coeficiente de reflexão    
polarplot(px);
title('Coeficiente de Reflexão (Complexo)')

