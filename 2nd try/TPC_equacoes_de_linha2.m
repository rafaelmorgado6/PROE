clear,clc,close all


%%  INPUT DATA 

Vg=2;           %Volts gerador   
Zg=50;          %Impedancia do gerador
Z0=Zg;          %Impedancia carateristica
l=1.00;         %comprimento da linha
f=300e6;        %frequencia (Hz)
alpha=0.02;        %constante de atenuação
ZL=20;         %User input

%%  Ex

x=linspace(1,300,601);   %vetor com 1000 pontos e com distancia de 1.25

lameda=300e6/f; %lameda= 300/f(em MHz)-> 300e6/f(em Hz) (SLIDE 6)
T=1/f;          %periodo    

beta=2*pi/lameda;   %constante de fase      (SLIDE 16)

w=2*pi*f;       %frequência angular

pl= (ZL-Z0)/(ZL+Z0); %coeficiente de refleção       (SLIDE 26)

alphaf = alpha*sqrt(f);
gama=alphaf+1i*beta; %constante de propagaçao     (SLIDE 15)

pin = pl*exp(-2*gama*1i);

figure(1);
polarplot(pin)
figure(2);
smithplot(pin)
