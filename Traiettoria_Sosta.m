% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Traiettoria_Sosta
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% In questa fase la sonda viaggia lungo un arco dell'orbita di Venere
% (si trascura il moto di rotazione della sonda attorno a Venere).

% coordinate del vettore posizione all'inizio della traiettoria di sosta
[x_venere, y_venere, z_venere] = Posizione_Pianeta(Pianeta(2), time_2);  
R5 = [x_venere, y_venere, z_venere];

% coordinate del vettore velocità all'inizio della traiettoria di sosta
[x_venere, y_venere, z_venere] = Velocita_Pianeta(Pianeta(2), time_2);  
V5 = [x_venere, y_venere, z_venere]/(24*3600);

% coordinate del vettore posizione alla fine della traiettoria di sosta
[x_venere, y_venere, z_venere] = Posizione_Pianeta(Pianeta(2), time_3);  
R6 = [x_venere, y_venere, z_venere];

% coordinate del vettore velocità alla fine della traiettoria di sosta
[x_venere, y_venere, z_venere] = Velocita_Pianeta(Pianeta(2), time_3);  
V6 = [x_venere, y_venere, z_venere]/(24*3600);

tempi = 0:1:days_3;
[x_sosta, y_sosta, z_sosta] = Posizione_Pianeta(Pianeta(2), time_2 + tempi);
pos_sosta = [x_sosta', y_sosta', z_sosta'];

props_sosta.Color = [1,0.8,0];
props_sosta.LineStyle = '-';
props_sosta.LineWidth = 1.2;

figure(f4)
plot3(pos_sosta(:,1), pos_sosta(:,2), pos_sosta(:,3), props_sosta)

figure(f1)
plot3(pos_sosta(:,1), pos_sosta(:,2), pos_sosta(:,3), props_sosta)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~