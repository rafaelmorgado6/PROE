%*************************************************************************
%
% NOME 1: Bruno Figueiredo
% MEC 1: 103489
% Turma: P4
% 
%*************************************************************************
%
% NOME 2: Laura Villalba
% MEC 2: 102847
% Turma: P4
% 
%**************************(apagar linhas que n�o interessam)*************
%
%% ******************* DADOS DE ENTRADA ************************************
fp= 150;    %Frequência de Projecto (em MHz)
fmax= 5*fp;  % Máxima frequência de simulação
LL=16*1e-9;      % L da carga em Henry (se existir): comentar a linha se não necessária
RL= 20;      % R da carga Ohms
Z0= 50;  % Impedância caracteristica

%% ****************************PROJECTO******************************
%***************Colocar aqui os valores calculados *************************
%%  Apague as linhas não usadas
lambdap= 300/fp;   % lambda (m) à frequência de projecto
ZLp= 20+15i;                        % Impedância de carga à frequencia de projecto
dp= 0.364*lambdap;      % distancia a carga onde se aplica a bobina (visto na carta de smith)
%etc, etc distãncias, comprimentos, valores nominais Nota: cálculos à frequência
%de projecto
Lp= 48.23*1e-9;                            % Indutância (H) da bobina de projecto (se existir)

%% *********************** Varrimendo em frequência**********************
f=1:1:fmax;     % Array de frequências em MHz e passo de 1 MHz (de preferência)
lambdaf=300./f;        % Comprimento de onda em função da frequência (m)
betaf=2*pi./lambdaf;          % Constante de fase em função da frequência (rad/m)
ZLf= 20+1i.*LL*2*pi*f*1e6;           %Impedância carga função da frequência (Atenção: a f e unidades de Cp e Lp)

%150 é a frequencia do circuito
% Impedância vista do plano pi- (calculo da impedancia de Ypi-)
ZpiMenos=Z0.*(ZLf+j.*Z0.*tan(betaf*dp))./(Z0+j.*ZLf.*tan(betaf*dp));
1/ZpiMenos(150)     %Verificação/debug: a condutância deve dar ~0.020 S e uma susceptância capacitiva (positiva)

% Impedançia da bobina em função da frequência 
ZB=j*2*pi*f*1E6*Lp; %lsp=0.118*lambdap; ZB=j*Z0.*tan(betaf*lsp);
1/ZB(150)       %Verificação/Debug: Deve dar uma susceptância de sinal contrário  à anterior
                %                   para eliminar a parte imaginaria

% Impedância vista do plano piMais: paralelo Bobina e ZpiMenos
Zin=   1./(1./ZpiMenos+1./ZB);         % Matching system input impedance as a function of frequency
Zin(150)    % Deve dar ~ 50+j0

%% ************************Display dos Resultados**********************
%**************************Carta de Smith e Grafico rectangular******
%
rhoin= (Zin-Z0)./(Zin+Z0);   % Coeficiente de reflexão como queremos a entrada temos de usar Zin e nao Zl
smithplot(rhoin);

figure(2); %Representar outros parametro num diagrama retangular
VSWR=(1+abs(rhoin))./(1-abs(rhoin));
plot(f,VSWR)
xlabel('f (MHz)')
ylabel('VSWR')
ylim([1 10])
grid on

%% Comentários aos resultados: Vale 5 valores
%     Dados:
% Os dados obtidos através deste script coincidiram com os dados calculados
% manualmente (apresentados na folha da carta de smith).
%
%    Smith plot:
% Uma vez que a curva deste gráfico passa perto do centro da
% circunferência, podemos admitir que o nosso sistema está bem adaptado à
% carga. Podemos ver que existe 1 ponto que passa no centro ou perto
% deste, por isso irá existir 1 frequência para a qual a carga fica +-
% adaptada. Esta frequências foi observada como mínimo no gráfico
% VSWR.
% 
%    VSWR:
% À frequência de projeto (150MHz), o VSWR tem valor unitário, logo podemos
% afirmar que Vmax = Vmin, assim afirmamos novamente que a carga está
% adaptada ao sistema. Entre a frequencia de 135MHz e 166MHz a carga está
% adaptada ao sistema, uma vez que VSWR está entre 1 e 2.