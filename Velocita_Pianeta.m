% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [vx_p, vy_p, vz_p] = Velocita_Pianeta(S, t) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  questa funzione fornisce la velocità lungo una traiettoria 
  circolare di un dato pianeta in un determinato istante k.

  S - struct dei dati del pianeta
  t - tempo in [giorni]
%}
% --------------------------------------------------------------

% calcolo longitudine eclittica alla data del 1 Gennaio 2018
theta = mod(S.L + 18 * 365.25/S.T * 360, 360) * 2*pi/360;
omega = 2*pi / S.T;     % calcolo della velocità angolare
rho = S.a;              % lunghezza raggio vettore del Pianeta

% vettore velocità in coordinate cartesiane
vx_p = -rho * omega * sin(omega .* t + theta);
vy_p =  rho * omega * cos(omega .* t + theta);
vz_p = 0 * t;

end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~