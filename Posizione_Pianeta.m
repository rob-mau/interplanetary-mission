% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [x_p ,y_p ,z_p] = Posizione_Pianeta(S, t) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  questa funzione fornisce la posizione lungo una traiettoria
  circolare di un dato pianeta in un determinato istante k.

  S - struct dei dati del pianeta
  t - tempo in [giorni]
%}
% --------------------------------------------------------------

% calcolo longitudine eclittica alla data del 1 Gennaio 2018
theta = mod(S.L + 18 * 365.25/S.T * 360, 360) * 2*pi/360;
omega = 2*pi / S.T;     % calcolo della velocità angolare
rho = S.a;              % lunghezza raggio vettore del Pianeta

% vettore posizione in coordinate cartesiane
x_p = rho * cos(omega .* t + theta);
y_p = rho * sin(omega .* t + theta);
z_p = 0 * t;

end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~