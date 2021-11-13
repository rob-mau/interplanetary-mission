% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Traiettoria_Hohmann
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% In questa fase la sonda viaggia lungo un'orbita semi-ellittica
% definita mediante una manovra di trasferimento alla Hohmann.

% tempo di volo in [secondi]
deltaT = days_4 * 24 * 3600;

% coordinate del vettore posizione all'inizio della manovra di Hohmann
[x_venere, y_venere, z_venere] = Posizione_Pianeta(Pianeta(2), time_3);  
R7 = [x_venere, y_venere, z_venere];

% modulo velocita all'inizio della manovra di Hohmann
vel_H1 = sqrt(2*mu/(Pianeta(1).a + Pianeta(2).a) * Pianeta(1).a/Pianeta(2).a);
% modulo velocita alla  fine della manovra di Hohmann
vel_H2 = sqrt(2*mu/(Pianeta(1).a + Pianeta(2).a) * Pianeta(2).a/Pianeta(1).a);

% vettore velocità all'inizio della manovra di Hohmann
V7 =  V6/norm(V6) * vel_H1;
% vettore velocità alla  fine della manovra di Hohmann
V8 = -V6/norm(V6) * vel_H2; 

% parametri orbitali classici
coe_hohmann = coe_from_sv(R7, V7, mu);

% inizializzazione contatore
i = 0;
% inizializzazione matrice dei vettori posizione
pos_hohmann = zeros(ceil(days_4), 3); 
% calcolo matrice dei vettori posizione
for dt = 0 :24*3600: deltaT
    i = i + 1;
    [R, V] = rv_from_r0v0(R7, V7, dt, mu);
    pos_hohmann(i,:) = R;
end

% coordinate del vettore posizione alla fine della manovra di Hohmann
R8 = R;

% impostazioni proprietà grafico traiettoria
props_hohmann.Color = [1,0.95,0];
props_hohmann.LineStyle = '-';
props_hohmann.LineWidth = 1.2;

figure(f5)
plot3(pos_hohmann(:,1), pos_hohmann(:,2), pos_hohmann(:,3), props_hohmann)

figure(f1)
plot3(pos_hohmann(:,1), pos_hohmann(:,2), pos_hohmann(:,3), props_hohmann)

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~