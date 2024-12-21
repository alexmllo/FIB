% numero de LIMAC
int: num_linacs;
set of 1..num_linacs: LINACS;

% pacientes van solicitando tandas de radioterapia
% numero de solicitudes de radioterapias (cada solicitud tiene varias sesiones)
int: num_solicitudes;
set of 1..num_solicitudes: SOLICITUDES;

% numero de sesiones por cada solicitud
array[SOLICITUDES] of int: num_sesiones;

% duracion de cada sesion para cada solicitud
array[SOLICITUDES, 1..max(num_sesiones)] of int: duracion_sesion;

% separacion ideal en dias entre sesiones consecutivas para cada solicitud
array[SOLICITUDES, 1..max(num_sesiones)-1] of int: separacion_ideal;

% fecha de solicitud de cada tanda en dias
array[SOLICITUDES] of int: fecha_solicitud;

% horario disponible de linacs en las proximas 3 semanas
array[LINACS, 1..21] of bool: linac_disponible;


% variables
% El dia en que se asignara cada sesion
array[SOLICITUDES, 1..max(num_sesiones)] of var 1..21: dia_sesion;

% El linac asignado a cada sesion
array[SOLICITUDES, 1..max(num_sesiones)] of var LINACS: linacs_asignados;


% Constraints

% 1. La primera sesion de una tanda debe estar ser programada dentro de los 8 días después de la solicitud
% 2. Cada sesion de las tandas nuevas debe ser asignada a un LINAC disponible en un dia determinado
% 3. El tiempo entre sesiones de una tanda debe ajustarse lo más posible a la separación ideal


% Objectivo
% Minimizar la diferencia total entre el tiempo real y el tiempo ideal que debe haber entre las sesiones.