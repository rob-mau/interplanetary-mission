clear all
close all
clc

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% MISSIONE INTERPLANETARIA - MAIN
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Assegnazione Parametri
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
global G M AU mu

G = 6.6726E-20;	% Costante di Gravitazione Universale [km^3/(kg*s^2)]
M = 1.989E30;	% Massa del Sole [kg]
mu = G * M;     % Parametro Gravitazionale [km^3/s^2]
AU = 149.6E6;	% Astronomical Unit [km] 

%{
Definizione di un array (Pianeta) di strutture che contengono i dati 
relativi a ciascun pianeta.
In particolare sono forniti:
- nome 
- massa (m) in [kg]
- raggio medio del globo (R) in [km]
- raggio medio della traiettoria (a) in [km]
- eccentricità (e) (posta a zero per semplicità di trattazione)
- periodo di rivoluzione (T) in [giorni]
- longitudine media (L) in [gradi]
- olbiquità sull'orbita (obl) in [gradi]
- raggio sfera d'influenza (R_sf) in [km]
- texture della superficie (nome file .jpg)
%}

%TERRA
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Pianeta(1) = struct('nome',     'Terra',	...
                    'm',        59.736E23,	...
                    'R',        6371.01,	...
                    'a',        1 * AU,     ...
                    'e',        0,          ...
                    'T',        365.25,     ...
                    'L',        100.46435,	...
                    'obl',      23.45,      ...
                    'R_sf',     924600,     ...
                    'texture',  'Texture\Cylindrical_Map_of_Earth');
                       
% VENERE
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Pianeta(2) = struct('nome',     'Venere',	...
                    'm',        48.685E23,	...
                    'R',        6051.84,	...
                    'a',        0.723 * AU,	...
                    'e',        0,          ...
                    'T',        224.70,     ...
                    'L',        181.97973,	...
                    'obl',      177.40,     ...
                    'R_sf',     616400,     ...
                    'texture', 'Texture\Cylindrical_Map_of_Venus');

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Stampa a Video dei Valori di Input 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fprintf('\n===============================================================');			
fprintf('\n Progetto 2017/18: Missione Interplanetaria');
fprintf('\n Studente: Roberto Mauceri');
fprintf('\n===============================================================');
fprintf('\n---------------------------------------------------------------');
fprintf('\n Dati di Input:');
fprintf('\n---------------------------------------------------------------');	

fprintf('\n   Parametro Gravitazionale del Sole [km^3/s^2] = %g\n', mu);

fprintf('\n   Dati Pianeta:  %s\n',                      Pianeta(1).nome);
fprintf('\n     - massa [kg] =                      %g', Pianeta(1).m);
fprintf('\n     - raggio medio [km] =               %g', Pianeta(1).R);
fprintf('\n     - raggio sfera d''influenza [km] =  %g', Pianeta(1).R_sf);
fprintf('\n     - distanza media [km] =             %g', Pianeta(1).a);
fprintf('\n     - periodo [giorni] =                %g', Pianeta(1).T);
fprintf('\n     - longitudine media [gradi] =       %g', Pianeta(1).L);
fprintf('\n     - obliquità [gradi] =               %g', Pianeta(1).obl);
fprintf('\n');

fprintf('\n   Dati Pianeta:  %s\n',                      Pianeta(2).nome);
fprintf('\n     - massa [kg] =                      %g', Pianeta(2).m);
fprintf('\n     - raggio medio [km] =               %g', Pianeta(2).R);
fprintf('\n     - raggio sfera d''influenza [km] =  %g', Pianeta(2).R_sf);
fprintf('\n     - distanza media [km] =             %g', Pianeta(2).a);
fprintf('\n     - periodo [giorni] =                %g', Pianeta(2).T);
fprintf('\n     - longitudine media [gradi] =       %g', Pianeta(2).L);
fprintf('\n     - obliquità [gradi] =               %g', Pianeta(2).obl);
fprintf('\n\n');

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Elaborazione dei Dati e Rappresentazione Grafica 3D
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
% parametri temporali della missione
% durata attesa prima dell'inizio della missione in giorni a partire
% dal 1 Gennaio 2018 ---> wait = 0 impone la partenza al 1 Gennaio
wait   = 243;
% durata volo pre  fly-by in [giorni]
days_1 = 120;
% durata volo post fly-by in [giorni]
days_2 = Pianeta(2).T;
% durata della sosta su Venere in [giorni] 
%(mi permette di raggiungere la configurazione necessaria 
% per effettuare Hohmann)
days_3 = Tempo_di_Attesa(Pianeta, wait + days_1 + days_2);
% durata volo Hohmann in [giorni]
days_4 = pi/(24 * 3600) * sqrt((Pianeta(1).a + Pianeta(2).a)^3/(8 * mu));

% tempi ausiliari in [giorni]
time_0 = wait;
time_1 = time_0 + days_1;
time_2 = time_1 + days_2;
time_3 = time_2 + days_3;
time_4 = time_3 + days_4; % tempo finale

%{
Alla fine dello script verranno calcolati i seguenti valori:

(R1, V1) - stato della sonda  all'inizio della traiettoria pre fly-by
(R2, V2) - stato della sonda alla fine della traiettoria pre fly-by

(R3, V3) - stato della sonda all'inizio della traiettoria post fly-by
(R4, V4) - stato della sonda alla fine della traiettoria post fly-by

(R5, V5) - stato della sonda all'inizio della traiettoria di sosta (dopo una spinta propulsiva)
(R6, V6) - stato della sonda alla fine della traiettoria di sosta

(R7, V7) - stato della sonda all'inizio della traiettoria di Hohmann
(R8, V8) - stato della sonda alla fine della traiettoria di Hohmann
%}

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%  Definizione Figure
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Figura 1: Missione - Fasi Eliocentriche
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% impostazioni grafiche della figura e degli assi
f1 = figure('Name', 'Missione - Fasi Eliocentriche', 'NumberTitle', 'off', 'Color', 'k');
axis vis3d equal off
axis([-1.2, 1.2, -1.2, 1.2, -0.6, 0.6] * AU);
view([0 0 1]) % permette di impostare la vista dall'alto
hold on

Grafica_Sole;
Grafica_Pianeta(Pianeta(1), time_4, '-.y');
Grafica_Pianeta(Pianeta(2), time_4, '-.y');

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Figura 2: Fase Pre FlyBy
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% impostazioni grafiche della figura e degli assi
f2 = figure('Name', 'Fase Pre FlyBy', 'NumberTitle', 'off', 'Color', 'k');
axis vis3d equal off
axis([-1.2, 1.2, -1.2, 1.2, -0.6, 0.6] * AU);
view([0 0 1]) % permette di impostare la vista dall'alto
hold on

Grafica_Sole;
Grafica_Pianeta(Pianeta(1), time_0, '-.w');
Grafica_Pianeta(Pianeta(2), time_0, '-.w');
Grafica_Pianeta(Pianeta(1), time_1, '-w');
Grafica_Pianeta(Pianeta(2), time_1, '-w');

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Figura 3: Fase Post FlyBy
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% impostazioni grafiche della figura e degli assi
f3 = figure('Name', 'Fase Post FlyBy', 'NumberTitle', 'off', 'Color', 'k');
axis vis3d equal off
axis([-1.2 1.2 -1.2 1.2 -0.6 0.6] * AU);
view([0 0 1]) % permette di impostare la vista dall'alto
hold on

Grafica_Sole;
Grafica_Pianeta(Pianeta(1), time_1, '-.w');
Grafica_Pianeta(Pianeta(2), time_1, '-.w');
Grafica_Pianeta(Pianeta(1), time_2, '-w');
Grafica_Pianeta(Pianeta(2), time_2, '-w');

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Figura 4: Fase Sosta
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% impostazioni grafiche della figura e degli assi
f4 = figure('Name', 'Fase Sosta', 'NumberTitle', 'off', 'Color', 'k');
axis vis3d equal off
axis([-1.2 1.2 -1.2 1.2 -0.6 0.6] * AU);
view([0 0 1]) % permette di impostare la vista dall'alto
hold on

Grafica_Sole;
Grafica_Pianeta(Pianeta(1), time_2, '-.w');
Grafica_Pianeta(Pianeta(2), time_2, '-.w');
Grafica_Pianeta(Pianeta(1), time_3, '-w');
Grafica_Pianeta(Pianeta(2), time_3, '-w');

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Figura 5: Fase Hohmann
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% impostazioni grafiche della figura e degli assi
f5 = figure('Name', 'Fase Hohmann', 'NumberTitle', 'off', 'Color', 'k');
axis vis3d equal off
axis([-1.2 1.2 -1.2 1.2 -0.6 0.6] * AU);
view([0 0 1]) % permette di impostare la vista dall'alto
hold on

Grafica_Sole;
Grafica_Pianeta(Pianeta(1), time_3, '-.w');
Grafica_Pianeta(Pianeta(2), time_3, '-.w');
Grafica_Pianeta(Pianeta(1), time_4, '-w');
Grafica_Pianeta(Pianeta(2), time_4, '-w');

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Calcoli + Grafica delle Traiettorie
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% le triettorie vengono calcolate e rappresentate sulle figure
% precedentemente definite

Traiettoria_PreFlyBy
[dati_fb, V3, V5] = FlyBy(Pianeta(2), time_1, V2);
Traiettoria_PostFlyBy
Traiettoria_Sosta 
Traiettoria_Hohmann

% quote delle orbite di parcheggio attorno alla terra e a venere
quota_t = 200;
quota_v = 500;

[dati_fug_t] = Fuga(Pianeta(1), time_0, quota_t, V1);
[dati_fug_v] = Fuga(Pianeta(2), time_3, quota_v, V7);

[dati_catt_t] = Cattura(Pianeta(1), time_4, quota_t, V8);
[dati_catt_v] = Cattura(Pianeta(2), time_2, quota_v, V4);

[dati_cp_t] = Cambio_Piano(Pianeta(1), quota_t, 'equatoriale');
[dati_cp_v] = Cambio_Piano(Pianeta(2), quota_v, 'polare');
 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Stampa a Video dei Valori di Output
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fprintf('---------------------------------------------------------------')	
fprintf('\n Dati di Output: \n');
fprintf('---------------------------------------------------------------')
fprintf('\n');
fprintf('---------------------------------------------------------------')	
fprintf('\n Traiettorie Eliocentriche: \n');
fprintf('---------------------------------------------------------------')

fprintf('\n   Parametri Caratteristici della Traiettoria di Pre-FlyBy: \n');
fprintf('\n     - semiasse maggiore [AU] =            %g', coe_pre_fb(1));
fprintf('\n     - eccentricità =                      %g', coe_pre_fb(2));
fprintf('\n     - tempo di volo [giorni] =            %g', days_1);
fprintf('\n     - distanza del pericentro [AU] =      %g', coe_pre_fb(1)*(1 - coe_pre_fb(2)));
fprintf('\n     - longitudine del pericentro [rad] =  %g', mod(coe_post_fb(3)+coe_post_fb(5), 2*pi));
fprintf('\n     - longitudine vera (inizio) [rad] =   %g', mod(coe_pre_fb(3)+coe_pre_fb(5)+real(coe_pre_fb(6)), 2*pi));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di Post-FlyBy: \n');
fprintf('\n     - semiasse maggiore [AU] =            %g', coe_post_fb(1));
fprintf('\n     - eccentricità =                      %g', coe_post_fb(2));
fprintf('\n     - tempo di volo [giorni] =            %g', days_2);
fprintf('\n     - distanza del pericentro [AU] =      %g', coe_post_fb(1)*(1 - coe_post_fb(2)));
fprintf('\n     - longitudine del pericentro [rad] =  %g', mod(coe_post_fb(3)+coe_post_fb(5), 2*pi));
fprintf('\n     - longitudine vera (inizio) [rad] =   %g', mod(coe_post_fb(3)+coe_post_fb(5)+real(coe_post_fb(6)), 2*pi));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di Sosta: \n');
fprintf('\n     - semiasse maggiore [AU] =            %g', Pianeta(2).a/AU);
fprintf('\n     - eccentricità =                      %g', Pianeta(2).e);
fprintf('\n     - tempo di volo [giorni] =            %g', days_3);
fprintf('\n     - distanza del pericentro [AU] =      %g', Pianeta(2).a/AU);
fprintf('\n     - longitudine vera (inizio) [rad] =   %g', mod(coe_post_fb(3)+coe_post_fb(5)+real(coe_post_fb(6)), 2*pi));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di Hohmann: \n');
fprintf('\n     - semiasse maggiore [AU] =            %g', coe_hohmann(1));
fprintf('\n     - eccentricità =                      %g', coe_hohmann(2));
fprintf('\n     - tempo di volo [giorni] =            %g', days_4);
fprintf('\n     - distanza del pericentro [AU] =      %g', coe_hohmann(1)*(1 - coe_hohmann(2)));
fprintf('\n     - longitudine del pericentro [rad] =  %g', mod(coe_hohmann(3)+coe_hohmann(5), 2*pi));
fprintf('\n     - longitudine vera (inizio) [rad] =   %g', mod(coe_hohmann(3)+coe_hohmann(5)+real(coe_hohmann(6)), 2*pi));
fprintf('\n');	

fprintf('---------------------------------------------------------------')	
fprintf('\n Traiettorie Planetocentriche: \n');
fprintf('---------------------------------------------------------------')

fprintf('\n   Parametri Caratteristici della Traiettoria di Fuga dalla Terra: \n');
fprintf('\n     - semiasse maggiore [km] =            %g', dati_fug_t(1));
fprintf('\n     - eccentricità =                      %g', dati_fug_t(2));
fprintf('\n     - tempo di volo [giorni] =            %g', dati_fug_t(4));
fprintf('\n     - distanza del pericentro [km] =      %g', Pianeta(1).R + quota_t);
fprintf('\n     - deltaV [km/s] =                     %g', dati_fug_t(3));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di Cattura da Parte di Venere: \n');
fprintf('\n     - semiasse maggiore [km] =            %g', dati_catt_v(1));
fprintf('\n     - eccentricità =                      %g', dati_catt_v(2));
fprintf('\n     - tempo di volo [giorni] =            %g', dati_catt_v(4));
fprintf('\n     - distanza del pericentro [km] =      %g', Pianeta(2).R + quota_v);
fprintf('\n     - deltaV [km/s] =                     %g', dati_catt_v(3));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di Fuga da Venere: \n');
fprintf('\n     - semiasse maggiore [km] =            %g', dati_fug_v(1));
fprintf('\n     - eccentricità =                      %g', dati_fug_v(2));
fprintf('\n     - tempo di volo [giorni] =            %g', dati_fug_v(4));
fprintf('\n     - distanza del pericentro [km] =      %g', Pianeta(2).R + quota_v);
fprintf('\n     - deltaV [km/s] =                     %g', dati_fug_v(3));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di Cattura da Parte della Terra: \n');
fprintf('\n     - semiasse maggiore [km] =            %g', dati_catt_t(1));
fprintf('\n     - eccentricità =                      %g', dati_catt_t(2));
fprintf('\n     - tempo di volo [giorni] =            %g', dati_catt_t(4));
fprintf('\n     - distanza del pericentro [km] =      %g', Pianeta(1).R + quota_t);
fprintf('\n     - deltaV [km/s] =                     %g', dati_catt_t(3));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di FlyBy: \n');
fprintf('\n     - semiasse maggiore [km] =            %g', dati_fb(1));
fprintf('\n     - eccentricità =                      %g', dati_fb(2));
fprintf('\n     - tempo di volo [giorni] =            %g', dati_fb(3));
fprintf('\n     - distanza del pericentro [km] =      %g', dati_fb(4));
fprintf('\n     - angolo di svolta [rad] =            %g', dati_fb(5));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di Cambio Piano Orbitale Terra: \n');
fprintf('\n     - velocità circolare [km/s] =         %g', dati_cp_t(1));
fprintf('\n     - deltaV [km/s] =                     %g', dati_cp_t(2));
fprintf('\n');

fprintf('\n   Parametri Caratteristici della Traiettoria di Cambio Piano Orbitale Venere: \n');
fprintf('\n     - velocità circolare [km/s] =         %g', dati_cp_v(1));
fprintf('\n     - deltaV [km/s] =                     %g', dati_cp_v(2));
fprintf('\n');	

durata_volo = days_1 + days_2 + days_3 + days_4;  
deltaV_tot =  dati_fug_t(3)  + dati_fug_v(3) ...
            - dati_catt_t(3) - dati_catt_v(3) ...
            + 2*(dati_cp_t(2) + dati_cp_v(2));

fprintf('---------------------------------------------------------------')	
fprintf('\n   Parametri Caratteristici della Missione: \n');
fprintf('---------------------------------------------------------------')	
fprintf('\n     - durata volo [giorni] =              %g', ceil(durata_volo));
fprintf('\n     - deltaV complessivo [km/s] =         %g', deltaV_tot);
fprintf('\n');
