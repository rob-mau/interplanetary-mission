% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function y = atan3 (a, b)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  atan2 con codominio in [0, 2*pi]

  a = seno dell'angolo
  b = coseno dell'angolo
  y = angolo (in radianti - y assume valori in [0, 2*pi])
%}
% --------------------------------------------------------------

epsilon = 0.0000000001;

if (abs(a) < epsilon)
    y = (1 - sign(b)) * pi/2;
    return;
else
    c = (2 - sign(a)) * pi/2;
end

if (abs(b) < epsilon)
    y = c;
    return;
else
    y = c + sign(a) * sign(b) * (abs(atan(a / b)) - pi/2);
end


end
