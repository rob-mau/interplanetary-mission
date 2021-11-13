% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Grafica_Pianeta(S, t, stile)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  questa funzione definisce le caratteristiche grafiche 
  dell'elemento pianeta. In particolare fornisce il grafico
  del globo e della sua orbita

  S     - struct dei dati del pianeta
  t     - tempo in [giorni]
  stile - stringa che definisce il tratto dell'orbita
%}
% --------------------------------------------------------------

% posizione pianeta in coordinate cartesiane
[x_p, y_p, z_p] = Posizione_Pianeta(S, t);

% raggio vettore pianeta-Sole
x_rv = linspace(0, x_p, 100);
y_rv = linspace(0, y_p, 100);
z_rv = linspace(0, z_p, 100);

% forma geometrica e estetica del pianeta
props.FaceColor = 'texture';
props.EdgeColor = 'none';
props.Cdata = imread(S.texture, 'jpg');

centro_pianeta = [x_p; y_p; z_p];
raggio_pianeta = S.R * 1000;  
% (scalato di un fattore 1000 per motivi pratici di raffigurazione)

[x,y,z] = ellipsoid(centro_pianeta(1), centro_pianeta(2), centro_pianeta(3), ...
                    -raggio_pianeta, -raggio_pianeta, -raggio_pianeta);
Globo = surface(x, y, z, props);
rotate(Globo, [1,0,0], S.obl,[centro_pianeta(1), centro_pianeta(2), centro_pianeta(3)])

% plottaggio della traiettoria
k = 0 :0.01: 1;

prop_t.Color = 'w';
prop_t.LineStyle = '-';
prop_t.LineWidth = 0.5;

% traiettoria pianeta in coordinate cartesiane
[x_t, y_t, z_t] = Posizione_Pianeta(S, k * S.T); % array di posizioni

plot3(x_t, y_t, z_t, prop_t)
plot3(x_rv, y_rv, z_rv, stile);

end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
