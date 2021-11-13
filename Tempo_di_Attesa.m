% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [t_a, csi_0, csi_h] = Tempo_di_Attesa(S, t)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  Questa funzione calcola il tempo necessario per raggiungere
  la configurazione da cui far partire una manovra di 
  trasferimento alla Hohmann
%}
% --------------------------------------------------------------

% angolo di sfasamento tra i pianeti necessario alla manovra 
% di Hohmann
csi_h = pi * (1 - ((1 + S(2).a/S(1).a)/2)^(3/2));

[xt_h, yt_h] = Posizione_Pianeta(S(1), t); 
[xv_h, yv_h] = Posizione_Pianeta(S(2), t);

% angolo di sfasamento attuale tra i pianeti
csi_0 = atan3(yt_h, xt_h) - atan3(yv_h, xv_h);

delta_csi = mod(csi_0 - csi_h, 2*pi);

% tempo d attesa
t_a = delta_csi/(2*pi) * (1/S(2).T - 1/S(1).T)^(-1);

end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~