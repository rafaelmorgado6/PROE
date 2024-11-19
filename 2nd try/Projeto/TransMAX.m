%% Sistemas a adaptar: Transformador lambda/4 colocado num máximo de tensão

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
fp= 765;                %Frequência de Projecto (em MHz)
fmax= 4*fp;             % Máxima frequência de simulação
CL=1.6195e-12;          % C da carga em Faraday (se existir)
RL= 49.45;              % R da carga Ohms
Z0= 50;                 % Impedância caracteristica

%% ****************************PROJECTO******************************
%***************Colocar aqui os valores calculados *************************
%%  Preencha apenas os dados usados
lambdap= 300/fp;            % lambda (m) à frequência de projecto em MHz
ZCp=49.45-128.46i;          % Impedância de carga à frequencia de projecto
dp= 0.444*lambdap;           % Distância (m) à carga de projecto
dquart= lambdap/4;          % Comprimento (m) do transformador de quarto de onda
Z01=sqrt(50*7.5*50);
%etc, etc distâncias, comprimentos, valores nominais 
% Nota: cálculos à frequência de projecto


%% *********************** Varrimendo em frequência**********************
% Preencher 
f=1:1:fmax;                     % Array de frequências em MHz e passo de 1 MHz (de preferência)
lambdaf=300./f;                 % Comprimento de onda em função da frequência (m)
betaf=2*pi./lambdaf;            % Constante de fase em função da frequência (rad/m)
ZCf= 49.45-1i./(CL*2*pi*f*1e6); %Impedância carga função da frequência (Atenção: a f e unidades de Cp e Lp)

% Cálculo ZPiMenos
ZPiMenos=Z0*(ZCf+1i.*Z0.*tan(betaf*dp))./(Z0+1i*ZCf.*tan(betaf*dp));
ZPiMenos(765)

% Impedância de entrada para o sistem de adaptação
Zin=Z01.*(ZPiMenos+1i*Z01.*tan(betaf*dquart))./(Z01+1i.*ZPiMenos.*tan(betaf*dquart)) ;     
Zin(765)
% Matching system input impedance as a function of frequency 

%% ************************Display dos Resultados**********************
%**************************Carta de Smith e Grafico rectangular******

rhoin= (Zin-Z0)./(Zin+Z0)   % Coeficiente de reflexão
smithplot(rhoin);

figure(2);                   % Representar outros parametro num diagrama retangular
T=1-abs(rhoin).^2;      
plot(f,T);                  % plot(f,*) % *pode ser Return Loss, Transmission, VSWR, Reflection Loss:
ylim([0 1])
xlabel('f (MHz)')
ylabel('T')
grid on;

%% Comentários aos resultados: Vale 5 valores
%
%%   Dados:
% Os dados obtidos neste script coincidiram com os dados calculados
% manualmente (apresentados na folha da carta de smith).
%
%%   Smith plot:
% Uma vez que a curva deste gráfico passa perto do centro da
% circunferência, podemos admitir que o nosso sistema está bem adaptado à
% carga. 
% Podemos ver que existem 3 pontos que passam perto
% deste, por isso irão existir 3 frequências para as quais a carga fica
% próxima de estar adaptada. Estas frequências foram observadas como máximos no gráfico
% da transmissão.
% 
%%   Transmissão:
% À frequência de projeto (765MHz), a Power Transmisson Coefficient é igual
% ou próximo a 1, ou seja, toda a potência incidente é entregue à carga, 
% deste modo podemos afirmar novamente que a carga está bem adaptada ao sistema.
% À frequência de 1725MHz, a Transmissão volta a ter o valor de 1, logo esta
% é outra frequência para a qual a carga está novamente adptada.
% Embora um pouco afastada de 1, à frequência de 3000MHz podemos também 
% afirmar que a carga está adaptada ao sistema.
