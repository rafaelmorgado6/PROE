%% Sistemas a adaptar: Capacidade C em paralelo na linha 

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
fp= 765;               %Frequência de Projecto (em MHz)
fmax= 4*fp;            % Máxima freqência de simulação
%LL=  NaN              % L da carga em Henry (se existir): comentar a linha se não necessária
CL=  1.6195*1e-12;     % C da carga em Faraday (se existir)
RL= 49.95;             % R da carga Ohms
Z0= 50;                % Impedância caracteristica

%% ****************************PROJECTO******************************
%***************Colocar aqui os valores calculados *************************
%%  Preencha apenas os dados usados
lambdap= 300/fp;             % lambda (m) à frequência de projecto em MHz
ZCp=49.95-1i*128.46;         % Impedância de carga à frequencia de projecto
Cp= 11.234*1e-12;            %  Capacidade (F) do condensador de projecto (se existir)
dp= 0.2540*lambdap;          % Distância (m) à carga de projecto
% etc, etc distâncias, comprimentos, valores nominais
% Nota: cálculos à frequência de projecto


%% *********************** Varrimendo em frequência**********************
% Preencher 
f=1:1:fmax;                        % Array de frequências em MHz e passo de 1 MHz (de preferência)
lambdaf=300./f;                    % Comprimento de onda em função da frequência (m)
betaf= 2*pi./lambdaf;              % Constante de fase em função da frequência (rad/m)
ZCf= RL-1i./(CL*2*pi*f*1e6);       % Impedância de carga em função da frequência (Atenção: a f e unidades de Cp e Lp)

%765 é a frequencia do circuito
% Impedância vista do plano pi- (calculo da impedancia de Ypi-)
ZpiMenos=Z0.*(ZCf+1i.*Z0.*tan(betaf*dp))./(Z0+1i.*ZCf.*tan(betaf*dp));
%1./ZpiMenos(765);    

% Impedânçia do condensador em função da frequência 
ZB=-1i./(2*pi*f*1E6*Cp); 
%1/ZC(765); % Verificação: Deve dar uma susceptância simétrica da anterior
 
% Impedância vista do plano piMais: paralelo condensador e ZpiMenos
Zin= ZpiMenos.*ZB./(ZpiMenos+ZB);         % Matching system input impedance as a function of frequency
%Zin(765)    

%% ************************Display dos Resultados**********************
%**************************Carta de Smith e Grafico rectangular******
%
rhoin= (Zin-Z0)./(Zin+Z0);   % Coeficiente de reflexão
smithplot(rhoin);

figure(2);                              %Representar outros parametro num diagrama retangular
VSWR=(1+abs(rhoin))./(1-abs(rhoin));
plot(f,VSWR)                            % plot(f,*) % *pode ser Return Loss, Transmission, VSWR, Reflection Loss:
xlabel('f (MHz)')
ylabel('VSWR')
ylim([0 10])
grid on


%% Comentários aos resultados: Vale 5 valores
%
%%    Dados:
% Os dados obtidos neste script coincidiram com os dados calculados
% manualmente (apresentados na folha da carta de smith).
%
%%   Smith plot:
% Uma vez que a curva deste gráfico passa perto do centro da
% circunferência, podemos concluir que o nosso sistema está bem adaptado à
% carga. 
% Podemos ver que existe 1 ponto que passa no centro da carta,
% por isso irá existir 1 frequência para a qual a carga fica
% adaptada. Esta frequência foi observada como mínimo no gráfico
% VSWR.
% 
%%   VSWR:
% À frequência de 750MHz, o VSWR tem valor unitário, logo podemos
% afirmar que Vmax = Vmin, assim podemos afirmar novamente que a carga está
% bem adaptada ao sistema. Entre a frequência de 720MHz e 780MHz a carga está
% adaptada ao sistema, uma vez que VSWR está entre 1 e 2.