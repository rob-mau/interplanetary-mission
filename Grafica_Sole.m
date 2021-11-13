% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Grafica_Sole
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%{
  questa funzione definisce le caratteristiche grafiche
  dell'elemento Sole e del sistema di riferimento 
  eliocentrico - eclittico
%}
% --------------------------------------------------------------
global AU

% definizione asse x
x_1 = linspace(0, 1.1 * AU, 100);
y_1 = zeros(1, 100);
z_1 = zeros(1, 100);

% definizione asse y
x_2 = zeros(1, 100);
y_2 = linspace(0, 1.1 * AU, 100);
z_2 = zeros(1, 100);

% definizione asse z
x_3 = zeros(1, 100);
y_3 = zeros(1, 100);
z_3 = linspace(0, 1.1 * AU, 100);

% plottaggio degli assi
plot3(x_1, y_1, z_1, ':w');
plot3(x_2, y_2, z_2, ':w');
plot3(x_3, y_3, z_3, ':w');

% definizione elemento Sole
props.FaceColor = 'texture';
props.EdgeColor = 'none';
props.Cdata = imread('Texture\Cylindrical_Map_of_Sun', 'jpg');

centro_sole = [0; 0; 0];
raggio_sole = 6.96E5 * 30; 
% (scalato di un fattore 30 per motivi pratici di raffigurazione)

[X, Y, Z] = ellipsoid(centro_sole(1), centro_sole(2), centro_sole(3), ...
                      raggio_sole, raggio_sole, raggio_sole, 30);

surface(X, Y, Z, props);

end
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~