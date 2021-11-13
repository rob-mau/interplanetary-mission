% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [dati] = Fuga(S, t, quota, v_s_u)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  questa funzione gestisce la manovra di fuga

  S         - struct del pianeta
  t         - tempo di inizio fuga (in giorni)
  quota     - quota orbita di parcheggio (in km)
  v_s_u     - vettore velocità in uscita alla SOI nel rif. eliocentrico

  dati = [a, e, deltaV, ToF, epsilon]
  a         - semiasse maggiore iperbole
  e         - eccentricità iperbole
  deltaV    - variazione velocità
  ToF       - time of flight
  epsilon   - angolo di inizio manovra

  G         - costante di gravitazione universale
  mu_p      - parametro gravitazionale del pianeta

  funzioni richieste:  atan3, conica, Posizione_Pianeta, Velocita_Pianeta
%}
% --------------------------------------------------------------
global G

raggio_pianeta = S.R;   % raggio pianeta
mu_p = G * S.m;         % parametro gravitazionale del pianeta
R_sf = S.R_sf;          % raggio sfera di influenza

% calcolo modulo della velocità circolare
v_c=sqrt(mu_p/(raggio_pianeta+quota));

% calcolo vettore velocità del pianeta
[vx_p, vy_p, vz_p] = Velocita_Pianeta(S,t);
v_p = [vx_p, vy_p, vz_p]/(24*3600);

% vettore velocità della sonda in uscita dalla SOI nel sist. di rif. relativo al pianeta
v_s_u_rel = v_s_u - v_p;
% modulo del vettore velocità della sonda in ingresso alla SOI nel sist. di rif. relativo al pianeta
mod_v_inf = norm(v_s_u_rel);
% angolo tra il vettore velocità sonda in ingresso alla SOI nel sist. di rif. relativo e l'asse x
gamma = atan3(v_s_u_rel(2),  v_s_u_rel(1));

% calcolo modulo della velocità al pericentro della traiettoria iperbolica
v_iper = sqrt(mod_v_inf^2 + 2*v_c^2);

% calcolo deltaV
deltaV = v_iper - v_c;
                                                 
% calcolo parametri orbitali 
a = -mu_p/(mod_v_inf )^2;           % semiasse maggiore
e = 1 - (raggio_pianeta + quota)/a; % eccentricità
phi = acos(1/e);                    % angolo di inclinazione asintoto: phi = (pi-delta)/2, con delta angolo di svolta
epsilon = pi + phi;                 % angolo di inizio manovra rispetto alla direzione del vettore velocità del pianeta
p = a * (1 - e^2);                  % semilato retto
th_bar = acos(1/e * (p/R_sf - 1));  % valore anomalia vera del punto che intercetta la SOI
F_bar = 2 * atanh(sqrt((e - 1)/(e + 1)) * tan(th_bar/2));	% anomalia eccentrica
M_bar = e * sinh(F_bar) - F_bar;							% anomalia media
ToF = M_bar * sqrt(-a^3/mu_p)/(24*3600);	% tempo di volo nella SOI in [giorni]

dati = [a, e, deltaV, ToF, epsilon]; 

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Grafica
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
theta = 0: 0.05: th_bar;
[x_t, y_t, z_t] = conica(a, e, theta);
[x_c, y_c, z_c] = conica(raggio_pianeta + quota, 0, [0: pi/100: 2*pi]);

figure('Name', 'Manovra di Fuga - Sistema di Riferimento del Pianeta', 'NumberTitle', 'off', 'Color', 'k')
axis vis3d equal off
l_asse = 10 * raggio_pianeta;
axis([-l_asse, l_asse, -l_asse, l_asse, -l_asse, l_asse]);
view([0,0,1]) % vista dall'alto
hold on

% raggio vettore pianeta-Sole
[x_p, y_p, z_p] = Posizione_Pianeta(S, t);
x_rv = -linspace(0, x_p/10^2, 100);
y_rv = -linspace(0, y_p/10^2, 100);
z_rv = -linspace(0, z_p/10^2, 100);
plot3(x_rv, y_rv, z_rv, '-.y');

%asintoti dell'iperbole
x_a= linspace(0, a * l_asse, 100) - e*a;
y_a= linspace(0, a * sqrt(e^2 - 1) * l_asse, 100);
z_a= zeros(1, 100);

% definizione degli elementi grafici
props_hyper.Color = 'r';
props_hyper.LineStyle = '-';
props_hyper.LineWidth = 1.2;

iperbole = plot3(x_t, y_t, z_t, props_hyper);
circonferenza = plot3(x_c, y_c, z_c, props_hyper);
asintoto1 = plot3(x_a, -y_a, z_a,'w');
asintoto2 = plot3(x_a, y_a, z_a,'w');
asse = plot3(x_a, 0 * y_a, z_a,'-.w');

% rotazione degli elementi grafici
angolo = (phi + gamma - pi) * 180/pi; % angolo di inclinazione asse focale iperbole
rotate(iperbole, [0,0,1], angolo, [0,0,0])
rotate(circonferenza, [0,0,1], angolo, [0,0,0])
rotate(asintoto1, [0,0,1], angolo, [0,0,0])
rotate(asintoto2, [0,0,1], angolo, [0,0,0])
rotate(asse, [0,0,1], angolo, [0,0,0])

% grafica della sonda
props_sat.FaceColor = 'w';
props_sat.EdgeColor = 'none';

[x_c, y_c, z_c]=conica(a, e, pi/3);
raggio_sat = 750; % non in scala per motivi pratici di raffigurazione
[x_sat, y_sat, z_sat] = ellipsoid(x_c, y_c, z_c, -raggio_sat, -raggio_sat, -raggio_sat);
satellite = surface(x_sat, y_sat, z_sat, props_sat);
rotate(satellite, [0,0,1], angolo, [0,0,0])

%grafica del pianeta
props_pianeta.FaceColor = 'texture';
props_pianeta.EdgeColor = 'none';
props_pianeta.Cdata = imread(S.texture,'jpg');

[x, y, z] = ellipsoid(0, 0, 0, -raggio_pianeta, -raggio_pianeta, -raggio_pianeta);
globo = surface(x, y, z, props_pianeta);
rotate(globo, [1,0,0], S.obl)
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~