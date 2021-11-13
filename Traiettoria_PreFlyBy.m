% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Traiettoria_PreFlyBy
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% In questa fase la sonda viaggia lungo un arco di orbita 
% ellittica che congiunge la Terra a Venere.
% E' stato usato il metodo di Lambert.

% tempo di volo in secondi
deltaT = days_1 * 24 * 3600; 

% coordinate del vettore posizione all'inizio della traiettoria pre-flyby
[x_terra, y_terra, z_terra] = Posizione_Pianeta(Pianeta(1), time_0); 
R1 = [x_terra, y_terra, z_terra];

% coordinate del vettore posizione alla fine della traiettoria pre-flyby
[x_venere, y_venere, z_venere] = Posizione_Pianeta(Pianeta(2), time_1);  
R2 = [x_venere, y_venere, z_venere];

% velocità iniziale e finale ottenuti tramite il metodo di Lambert
[V1, V2] = lambert(R1, R2, deltaT, 'pro', mu); 

% parametri orbitali classici
coe_pre_fb = coe_from_sv(R1, V1, mu); 

% inizializzazione contatore
i = 0;
% inizializzazione matrice dei vettori posizione
pos_pre_fb = zeros(ceil(days_1), 3);
% calcolo matrice dei vettori posizione
for dt = 0 :24*3600: deltaT
    i = i + 1;
    [R, V] = rv_from_r0v0(R1, V1, dt, mu);
    pos_pre_fb(i,:) = R;
end

% impostazioni proprietà grafico traiettoria
props_pre_fb.Color = [1,0.4,0];
props_pre_fb.LineStyle = '-';
props_pre_fb.LineWidth = 1.2;

figure(f2)
plot3(pos_pre_fb(:,1), pos_pre_fb(:,2), pos_pre_fb(:,3), props_pre_fb)

figure(f1)
plot3(pos_pre_fb(:,1), pos_pre_fb(:,2), pos_pre_fb(:,3), props_pre_fb)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~