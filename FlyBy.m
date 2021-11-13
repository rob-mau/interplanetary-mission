% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [dati, v_s_u, v_p] = FlyBy(S, t, v_s_i)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  questa funzione gestisce la manovra di fly-by (incontro iperbolico)

  S         - struct del pianeta
  t         - tempo di inizio flyby (in giorni)
  v_s_i     - vettore velocità in ingresso alla SOI nel rif. eliocentrico
  v_s_u     - vettore velocità in uscita alla SOI nel rif. eliocentrico

  dati = [a, e, ToF, rp, delta]
  a         - semiasse maggiore iperbole
  e         - eccentricità iperbole
  ToF       - time of flight
  rp        - distanza pericentro iperbole
  delta     - angolo tra vettore velocità sonda in uscita dalla SOI e 
              vettore velocità sonda in ingresso alla SOI nel sist. di 
              rif. relativo

  gamma     - angolo di svolta
  G         - costante di gravitazione universale
  mu        - parametro gravitazionale del Sole
  mu_p      - parametro gravitazionale del pianeta

  funzioni richieste:  atan3, conica, Posizione_Pianeta, Velocita_Pianeta
%}
% --------------------------------------------------------------
global G mu

r = S.a;            % lunghezza raggio vettore del pianeta
T = S.T * 3600*24;  % periodo orbita del pianeta
mu_p = G * S.m;     % parametro gravitazionale del pianeta
R_sf=S.R_sf;        % raggio sfera di influenza

% calcolo vettore velocità pianeta
[vx_p, vy_p, vz_p] = Velocita_Pianeta(S,t);
v_p = [vx_p, vy_p, vz_p]/(24*3600);

v_s_i_rel = v_s_i - v_p;        % vettore velocità della sonda in ingresso alla SOI nel sist. di rif. relativo al pianeta
mod_v_p = norm(v_p);            % modulo vettore velocità pianeta nel sist. di rif. eliocentrico
mod_v_s_rel = norm(v_s_i_rel);  % modulo del vettore velocità della sonda in ingresso alla SOI nel sist. di rif. relativo al pianeta
                                % NOTA: è uguale al modulo del corrispondente vettore in uscita
 
% elementi ausiliari per il calcolo di beta e di delta
by = v_p(2);
bx = v_p(1);

cy = v_s_i_rel(2);
cx = v_s_i_rel(1);

% modulo del vettore velocità della sonda in uscita dalla SOI nel sist. di
% rif. eliocentrico affinché si abbia una traiettora post fly-by con
% periodo pari a quello del pianeta
mod_v_s_ass = (2 * mu/r - (2*pi * mu/T)^(2/3))^(1/2);
 
% angolo tra vettore velocità pianeta e vettore velocità sonda in uscita dalla SOI nel sist. di rif. relativo
alpha = acos((mod_v_s_ass^2 - mod_v_s_rel^2 - mod_v_p^2)/(2 * mod_v_s_rel * mod_v_p)); 
% NOTA: esiste anche la soluzione di segno opposto, ma serve per flyby che
% producano un incremento dell'energia cinetica della sonda

% angolo tra vettore velocità pianeta e vettore velocità sonda in ingresso alla SOI nel sist. di rif. relativo
beta = atan3(cy, cx) - atan3(by, bx) ; 
% angolo tra il vettore velocità sonda in ingresso alla SOI nel sist. di rif. relativo e l'asse x
gamma = atan3(cy, cx);
% angolo tra vettore velocità sonda in uscita dalla SOI e vettore velocità
% sonda in ingresso alla SOI nel sist. di rif. relativo 
delta = alpha - beta;

% calcolo parametri orbitali 
a = -mu_p/(mod_v_s_rel )^2;         % semiasse maggiore
e = (1 / sin(delta/2));             % eccentricità
p = a * (1 - e^2);                  % semilato retto
rp = a * (1 - e);                   % distanza pericentro
th_bar = acos(1/e * (p/R_sf - 1));	% valore anomalia vera del punto che intercetta la SOI
F_bar = 2*atanh(sqrt((e - 1)/(e + 1)) * tan(th_bar/2));     % anomalia eccentrica
M_bar = e * sinh(F_bar) - F_bar;                            % anomalia media
ToF = 2*M_bar * sqrt(-a^3/mu_p)/(24*3600);	% tempo di volo nella SOI in [giorni]

dati = [a, e, ToF, rp, delta]; 

% vettore velocità sonda in uscita dalla SOI nel sist. di rif. eliocentrico
Rot = [cos(delta), -sin(delta), 0; sin(delta) cos(delta) 0; 0 0 1];
v_s_u = (Rot * (v_s_i_rel)' + v_p')';

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Grafica
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
theta = -th_bar:0.05:th_bar;
raggio_pianeta = S.R;
[x_t, y_t, z_t] = conica(a,e,theta);

figure('Name', 'Manovra di FlyBy (Incontro Iperbolico) - Sistema di Riferimento del Pianeta', 'NumberTitle', 'off', 'Color', 'k')
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
props_hyper.Color ='r';
props_hyper.LineStyle = '-';
props_hyper.LineWidth = 1.2;

iperbole = plot3(x_t, y_t, z_t, props_hyper);
asintoto1 = plot3(x_a,-y_a, z_a,'w');
asintoto2 = plot3(x_a, y_a, z_a,'w');
asse = plot3(x_a, 0 * y_a, z_a,'-.w');

% rotazione degli elementi grafici
angolo = (gamma - (pi - delta)/2) * 180/pi; % angolo di inclinazione dell'asse degli apsidi risp. all'asse x
rotate(iperbole, [0,0,1], angolo, [0,0,0])
rotate(asintoto1, [0,0,1], angolo, [0,0,0])
rotate(asintoto2, [0,0,1], angolo, [0,0,0])
rotate(asse, [0,0,1], angolo, [0,0,0])

% grafica della sonda
props_sat.FaceColor = 'w';
props_sat.EdgeColor = 'none';

[x_c,y_c,z_c] = conica(a, e, pi/3);
raggio_sat = 750;
[x_sat,y_sat,z_sat] = ellipsoid(x_c, y_c, z_c, -raggio_sat, -raggio_sat, -raggio_sat);
satellite = surface(x_sat, y_sat, z_sat, props_sat);
rotate(satellite, [0,0,1], angolo, [0,0,0])

% grafica del pianeta
props_pianeta.FaceColor = 'texture';
props_pianeta.EdgeColor = 'none';
props_pianeta.Cdata = imread(S.texture,'jpg');

[x,y,z] = ellipsoid(0, 0, 0, -raggio_pianeta, -raggio_pianeta, -raggio_pianeta);
globo = surface(x, y, z, props_pianeta);
rotate(globo, [1,0,0], S.obl)
end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

