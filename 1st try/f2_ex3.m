%) 3
% a)

D = 1.12;
d = 0.56
E0 = 8.85 * 10^(-12);
Er = 2.25;
Ed = E0 * Er;



C = (pi*Ed)/(log((D/d)+sqrt((D/d)^2 - 1)))

u0 = 4*pi*10^(-7);
ur = 1;
ud = u0 * ur;

L = (ud/pi)*log((D/d)+sqrt((D/d)^2 -1 ))

% b)

z0 = sqrt(L/C)

% c)
dm = d * 10*(-3);
f = 400 * 10^(6);
w = 2*pi*f;

Rs = sqrt((u0*w)/(2*5.8*10^(-7)));
R = (2*Rs)/pi*dm;

alpha = R/(2*z0)

alfa = alpha * 8.686
