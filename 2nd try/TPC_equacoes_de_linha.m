clear,clc,close all

%% PRIMEIRA PARTE 


%%  INPUT DATA 

Vg=2;           %Volts gerador   
Zg=50;          %Impedancia do gerador
Z0=Zg;          %Impedancia carateristica
l=1.25;         %comprimento da linha
f=300e6;        %frequencia (Hz)
alpha=0;        %constante de atenuação
ZL=100;         %User input

%%  Ex 1

lameda=300e6/f; %lameda= 300/f(em MHz)-> 300e6/f(em Hz) (SLIDE 6)
T=1/f;          %periodo    
pl= (ZL-Z0)/(ZL+Z0); %coeficiente de refleção       (SLIDE 26)

beta=2*pi/lameda;   %constante de fase      (SLIDE 16)
gama=alpha+1i*beta; %constante de propagaçao     (SLIDE 15)

w=2*pi*f;       %frequência angular

x=linspace(0,l,1000);   %vetor com 1000 pontos e com distancia de 1.25


%%  Ex 2

%% a. ONDAS INCIDENTES (VOLTAGEM E CORRENTE)
   
Vi=Vg/2*exp(-gama*x);   %Tensão Incidente  (SLIDE 60) ->Vg/2 pois temos
                        %um divisor resistivo:  Vo=Vg*Zo/(Zo+Zg)
Ii=Vi/Z0;               %Corrente Incidente (SLIDE 60)

%% b. ONDAS REFLETIDAS (VOLTAGEM E CORRENTE)

Vr=Vg/2*exp(-2*gama*l)*pl*exp(gama*x);  %Tensão Refletida (SLIDE 60)
Ir=-Vr/Z0;                               %Corrente Refletida (SLIDE 60)

%%  Ex 3

Vstand = abs(Vi + Vr);  %Vetor de amplitude da tensão da onda estacionária

figure(1)
plot(x,Vstand); %Gráfico
grid on
title('Tensão da onda estacionária')
xlabel('Comprimento da linha (m)')
ylabel('Voltage (V)')

%VOLTAGE STANDING WAVE RATIO/RAZAO DE TENSAO DA ONDA ESTACIONARIA(Slide 75)
VSWRg=max(Vstand)/min(Vstand); %Usando os gráficos
VSWRc=(1+abs(pl))/(1-abs(pl)); %Usando calculos

%%  Ex 4
Istand = abs(Ii + Ir);   %Vetor de amplitude da corrente da onda estacionária

hold on         %manter o grafico anterior
plot(x,50*Istand,'r')
title('Tensão e Corrente da onda estacionária')
ylabel('Voltage (V) / Corrente (A)')
legend('Vstand','Istand')
hold off

%%  Ex 5
figure(2)
plot(x,Vstand,'b',x,-Vstand,'b',x,50*Istand,'r',x,50*(-Istand),'r')
grid on
title('Tensão e Corrente da onda estacionária e seus simétricos')
xlabel('Comprimento da linha (m)')
ylabel('Voltage (V) / Corrente (A)')
legend('Vstand','-Vstand','Istand','-Istand')

%%  Ex 6
Tstep=T/32;     %Time step

%% a. 
% figure(3)
% plot(x,real(Vi+Vr),'b',x,real(50*(Ii+Ir)),'r')   %temos de usar o grafico do 4. mas sem o valor absoluto
% title('Tensão e Corrente da onda estacionária')
% xlabel('Comprimento da linha (m)')
% ylabel('Voltage (V) / Corrente (A)')
% legend('Vstand','Istand')
% grid on

%% b.
ylim([-1.5,1.5]);    % congelar o eixo dos y dos 0.5 aos 1.5

%% c.
hold on

%% d.
t1=0;

%% e.
for k=1:32*5  % retirei o *5 porque se nao demora muito tempo
    
%%  i.
hv = plot(x,real((Vi+Vr).*exp(1i*w*t1)),'c');    

%%  ii.
hi = plot(x,real((50*(Ii+Ir)).*exp(1i*w*t1)),'m'); 

%%  iii.
pause(0.1);

%%  iv.
t1=t1+Tstep;

%%  v.
delete(hv);
delete(hi);
end

%%  Ex 7

%->É uma onda estacionária, pois estas ondulam dentro do "espartilho" , mas o
%padrão criado não se move.
%->Nos pontos de máximo e mínimo, a tensão e a corrente na linha estão em
%fase (180º)
%->Nos pontos entre a tensão/corrente e o extremo da natureza oposta
%(-tensão/corrente) é de +-90º

%%  Ex 8

figure(4)
rho=Vr./Vi;     % coeficiente de reflexão    (Slide 65)
polarplot(rho);
title('Coeficiente de Reflexão (Complexo)')


%% SEGUNDA PARTE


%% Ex 1
Zin=(Vi+Vr)./(Ii+Ir);   %impedancia de entrada (Slide 83)

figure(5)
plot(x,real(Zin),'b',x,imag(Zin),'r')
grid on
title('Impedância de Entrada')
legend('Resistência','Reactância')
xlabel('Comprimento da linha (m)')
ylabel('Impedância (Ω)')

%%  Ex 2
%Para vermos a distância mais próxima temos de ver quando é que a
%reatancia=0 e a resistencia maxima;

y=imag(Zin);
y1=real(Zin);

hold on
h=plot(x(1),y(1),'ro');     %criar o ponto no gráfico
j=plot(x(1),y1(1),'ro');
x1=[];

for n=1:length(Zin)
    set(h,'XData',x(n),'YData',y(n))        %mover o ponto
    set(j,'XData',x(n),'YData',y1(n))

    if ((round(y(n))== 0 ) && ( y1(n) == max(y1(n))))
        x1(n)=x(n);     %retirar todos os pontos em que x1 interseta o 0
    end

    pause(0.0000001)       %tempo que o ponto demora a se mover
end

hold off

x1(x1==0)=[];               %REMOVER TODOS OS PONTOS QUE NÃO INTERESSAM
x1((x1>=0.3)&(x1<=0.7))=[];
x1((x1>=0)&(x1<=0.2))=[];
x1(x1>=0.8)=[];             

distancia=x1(2)-x1(1);      %0.4992 m

%%  Ex 3

Yin = 1./Zin;
figure(6)

plot(x, real(Yin),x ,imag(Yin))
grid on; 
title('Admitância de Entrada')
legend('Admitância', 'Suscetância')
xlabel('Comprimento da linha (m)')
ylabel('Admitância (S)')

%%  Ex 4    -> fazer again
%Para vermos a distância mais próxima temos de ver quando é que a
%reatancia=0 e a resistencia maxima;

y2=imag(Yin);
y3=real(Yin);

hold on
h=plot(x(1),y2(1),'ro');     %criar o ponto no gráfico
j=plot(x(1),y3(1),'ro');
x1=[];

for n=1:length(Zin)
    set(h,'XData',x(n),'YData',y2(n))        %mover o ponto
    set(j,'XData',x(n),'YData',y3(n))

    if ((round(y(n))== 0 ) && ( y2(n) == max(y3(n))))
        x1(n)=x(n);     %retirar todos os pontos em que x1 interseta o 0
    end

    pause(0.00001)       %tempo que o ponto demora a se mover
end

hold off

x1(x1==0)=[];               %REMOVER TODOS OS PONTOS QUE NÃO INTERESSAM
x1((x1>=0.3)&(x1<=0.7))=[];
x1((x1>=0)&(x1<=0.2))=[];
x1(x1>=0.8)=[];             

distancia2=x1(2)-x1(1);      %

%%  Ex 5

