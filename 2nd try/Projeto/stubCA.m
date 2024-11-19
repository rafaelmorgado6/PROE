%% Sistema a adaptar: Stub em CA

%*************************************************************************
%
% NOME 1: Rafael Morgado
% MEC 1: 104277
% Turma: P1
% 
%*************************************************************************
%
% NOME 2: Bruno Monteiro
% MEC 2: 102084
% Turma: P1
% 
%**************************(apagar linhas que não interessam)*************
%
clear,clc,close all
%% ******************* DADOS DE ENTRADA ************************************
% Preencher o Necessário
fp= 765;             %Frequência de Projecto (em MHz)
fmax= 4*fp;         % Máxima frequêencia de simulação
CL= 1.6195*1e-12;    % C da carga em Faraday (se existir)
RL= 49.95;           % R da carga Ohms
Z0= 50;             % Impedância caracteristica

%% ****************************PROJECTO******************************
%***************Colocar aqui os valores calculados *************************
%%  Preencha apenas os dados usados
lambdap= 300/fp;        % lambda (m) à frequência de projecto em MHz
ZCp=49.95-1i*128.46;    % Impedância de carga à frequencia de projecto
dp= 0.25*lambdap;       % Distância (m) à carga de projecto
lcp= 0.191*lambdap;     % Comprimento (m) do stub de projecto


%% *********************** Varrimendo em frequ�ncia**********************
% Preencher 
f=1:1:fmax;             % Array de frequências em MHz e passo de 1 MHz (de preferência)
lambdaf=300./f;         % Comprimento de onda em função da frequência (m)
betaf= 2*pi./lambdaf;   % Constante de fase em função da frequência (rad/m)
ZCf= RL-1i./(CL*2*pi*f*1e6);    %Impedância carga função da frequência (Atenção: a f e unidades de Cp e Lp)

%765 é a frequencia do circuito
% Impedância vista do plano pi- (calculo da impedancia de Ypi-)
ZpiMenos=Z0.*(ZCf+1i.*Z0.*tan(betaf*dp))./(Z0+1i.*ZCf.*tan(betaf*dp));
%1./ZpiMenos(765)


% Impedançia do stub em função da frequência 
ZB=-1i*Z0.*cot(betaf*lcp);
%1./ZB(765)


% Impedância de entrada para o sistem de adaptação
Zin= ZpiMenos.*ZB./(ZpiMenos+ZB) ;          % Matching system input impedance as a function of frequency
%Zin(765)

%% ************************Display dos Resultados**********************
%**************************Carta de Smith e Grafico rectangular******
%
rhoin= (Zin-Z0)./(Zin+Z0);   % Coeficiente de reflexão
smithplot(rhoin);

figure(2);          %Representar outros parametro num diagrama retangular
VSWR=(1+abs(rhoin))./(1-abs(rhoin));
plot(f,VSWR)        % plot(f,*) % *pode ser Return Loss, Transmission, VSWR, Reflection Loss:
ylim([0 10])
xlabel('f (MHz)')
ylabel('VSWR')

grid on

%% Comentários aos resultados: Vale 5 valores
% 
%%  Dados:
% Os dados obtidos neste script coincidiram com os dados calculados
% manualmente (apresentados na folha da carta de smith).
%
%%  Smith plot:
% Uma vez que a curva deste gráfico perto do centro da
% circunferência, podemos concluir que o nosso sistema está bem adaptado à
% carga. 
% Podemos ver que existe 1 ponto que passa no centro ou perto
% deste, por isso irá existir 1 frequência (~765 MHz) para a qual a carga fica
% adaptada. Esta frequência foi observada como mínimo no gráfico
% VSWR.
%
%%  VSWR:
% À frequência de projeto (765MHz), o VSWR tem valor unitário, logo podemos
% afirmar que Vmax = Vmin, assim afirmamos novamente que a carga está
% adaptada ao sistema. Entre as frequências de 1600MHz a 1760MHZ e 2180MHz a 2470MHZ a carga está
% adaptada ao sistema, uma vez que VSWR está entre 1 e 2.