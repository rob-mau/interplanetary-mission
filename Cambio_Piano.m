% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [dati] = Cambio_Piano(S, quota, stringa)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  questa funzione gestisce la manovra di modifica del piano orbitale

  S           - struct del pianeta
  quota       - quota orbita di parcheggio (in km)
  stringa     - riceve le possibili opzioni: 'equatoriale' o 'polare'

  dati = [v_c, deltaV]
  v_c         - velocità circolare 
  deltaV      - variazione velocità

  G           - costante di gravitazione universale
  mu_p        - parametro gravitazionale del pianeta

  funzioni richieste:  conica
%}
% --------------------------------------------------------------
global G

mu_p = G * S.m;
raggio_pianeta = S.R;

switch stringa
    case 'equatoriale'
  theta = S.obl * pi/180;
    case 'polare'
  theta = S.obl * pi/180 - pi/2;    
end

% calcolo della velocità circolare
v_c = sqrt(mu_p/(raggio_pianeta + quota));
% calcolo del deltaV
deltaV = 2 * v_c * sin(theta/2);

dati = [v_c, deltaV];

% definizione circonferenza 
[x_c, y_c, z_c] = conica(raggio_pianeta + quota, 0, [0: pi/50: 2*pi]);

% definizione asse 
x_n = zeros(1, 100);
y_n = zeros(1, 100);
z_n = linspace(-1.5 * raggio_pianeta, 1.5 * raggio_pianeta);

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Grafica
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
figure('Name', 'Manovra di Cambio Piano - Sistema di Riferimento del Pianeta', 'NumberTitle', 'off', 'Color', 'k')
axis vis3d equal off
l_asse = 1.5 * raggio_pianeta;
axis([-l_asse, l_asse, -l_asse, l_asse, -l_asse, l_asse]);
view([-1, -1, 0.5])
hold on

% proprietà circonferenza eclittica
props_circle1.Color = [1,0,1];
props_circle1.LineStyle = '-';
props_circle1.LineWidth = 1.5;

% proprietà circonferenza equatoriale
props_circle2.Color = [1,0,0];
props_circle2.LineStyle = '-';
props_circle2.LineWidth = 1.5;

% plottaggio circonferenze e assi
circonferenza1 = plot3(x_c, y_c, z_c, props_circle1);
circonferenza2 = plot3(x_c, y_c, z_c, props_circle2);
asse1 = plot3(x_n, y_n, z_n, '-.w');
asse2 = plot3(x_n, y_n, z_n, '-.w');
rotate(circonferenza1, [1,0,0], theta * 180/pi, [0,0,0])
rotate(circonferenza2, [1,0,0], 0, [0,0,0])
rotate(asse1, [1,0,0], S.obl, [0,0,0])
rotate(asse2, [1,0,0], 0, [0,0,0])

%grafica del pianeta
props_pianeta.FaceColor = 'texture';
props_pianeta.EdgeColor = 'none';
props_pianeta.Cdata = imread(S.texture, 'jpg');

[x, y, z] = ellipsoid(0, 0, 0, -raggio_pianeta, -raggio_pianeta, -raggio_pianeta);
globo = surface(x, y, z, props_pianeta);
rotate(globo, [1,0,0], S.obl)

end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
