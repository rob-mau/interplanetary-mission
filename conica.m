% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [x, y, z] = conica(a, e, theta)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  dato in input un arco di conica (definito da semiasse maggiore,
  eccentricità e vettore di angoli) fornisce in output una 
  sequenza di punti nello spazio cartesiano.

  a     - semiasse maggiore
  e     - eccentricità
  theta - vettore di angoli (in radianti)
%}
% ----------------------------------------------

rho = a * (1 - e^2)./(1 + e * cos(theta));

x = rho .* cos(theta);
y = rho .* sin(theta);
z = 0 * theta;

end