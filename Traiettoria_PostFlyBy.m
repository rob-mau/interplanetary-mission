% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Traiettoria_PostFlyBy
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% In questa fase la sonda viaggia lungo un'orbita ellittica completa
% caratterizzata dall'avere un periodo identico all'orbita di Venere.
% La velocità iniziale è imposta dalla precedente fase di fly-by.

% tempo di volo in [secondi]
deltaT = days_2 * 24 * 3600; 

% coordinate del vettore posizione all'inizio della traiettoria post-flyby
[x_venere, y_venere, z_venere] = Posizione_Pianeta(Pianeta(2), time_1);  
R3 = [x_venere, y_venere, z_venere];

% parametri orbitali classici
coe_post_fb = coe_from_sv(R3, V3, mu); 

% inizializzazione contatore
i = 0; 
% inizializzazione matrice dei vettori posizione
pos_post_fb = zeros(ceil(days_2), 3);
% calcolo matrice dei vettori posizione
for dt = 0 :24*3600: deltaT
    i = i + 1;
    [R, V] = rv_from_r0v0(R3, V3, dt, mu);
    pos_post_fb(i,:) = R;
end

% coordinate del vettore posizione alla fine della traiettoria post-flyby
R4 = R3;
% coordinate del vettore velocità alla fine della traiettoria post-flyby
V4 = V3;

% impostazioni proprietà grafico traiettoria
props_post_fb.Color = [1,0.6,0];
props_post_fb.LineStyle = '-';
props_post_fb.LineWidth = 1.2;

figure(f3)
plot3(pos_post_fb(:,1), pos_post_fb(:,2), pos_post_fb(:,3), props_post_fb)

figure(f1)
plot3(pos_post_fb(:,1), pos_post_fb(:,2), pos_post_fb(:,3), props_post_fb)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~