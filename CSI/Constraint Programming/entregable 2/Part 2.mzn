% Use this editor as a MiniZinc scratch book
include "globals.mzn";

int: CAPACITY = (12 * 60) div 15; % Capacidad diaria de cada LINAC en cuartos de hora
set of int: DAY = 1..7 * 3; % Dias en tres semanas
int: m; % Número de LINACs
set of int: LINAC = 1..m;
array[LINAC, DAY] of 0..CAPACITY: disponible; % Tiempo disponible en cada LINAC por dia

int: p; % Numero de pacientes
set of int: PACIENTE = 1..p;
int: s; % Numero de sesiones por tanda
set of int: SESION = 1..s;

array[PACIENTE] of 1..5: solicitud; % Dia laboral en que se hizo la solicitud
array[PACIENTE, SESION] of int: duracion; % Duracion de cada sesion (en multiplos de 15 min)
array[PACIENTE, SESION] of int: separacion; % Separacion ideal entre sesiones

% Variables
array[PACIENTE, SESION] of var DAY: dia_asignado; % Dia asignado a cada sesion
array[PACIENTE, SESION] of var LINAC: linac_asignado; % linac asignado a cada sesion

array[PACIENTE, 2..s] of var int: desvio; % Desvío entre sesiones

% Cada sesion debe ajustarse al tiempo disponible en el linac asignado
constraint forall(pa in PACIENTE, se in SESION)(disponible[linac_asignado[pa,se], dia_asignado[pa,se]] >= duracion[pa,se]);

% La primera sesion debe empezar como maximo 8 dias despues de la solicitud
constraint forall(pa in PACIENTE)(dia_asignado[pa,1] >= solicitud[pa] /\ dia_asignado[pa,1] <= solicitud[pa] + 8);

% Cada paciente no puede tener mas de una sesion al mismo dia
constraint forall(pa in PACIENTE, se in 1..s-1)(dia_asignado[pa,se+1] > dia_asignado[pa,se]);

% Todo el tiempo ocupado de todas las sesiones de un dia a un linac no puede superar el tiempo disponible de este linac
constraint forall(l in LINAC, d in DAY)(sum(pa in PACIENTE, se in SESION where dia_asignado[pa,se]=d /\ linac_asignado[pa,se]=l)(duracion[pa,se]) <= disponible[l,d]);


% Tenemos que minimizar el desvio maximo entre la separacion ideal entre sesiones

% Calculo el desvio entre sesiones
constraint forall(pa in PACIENTE, se in 2..s)(desvio[pa,se] = dia_asignado[pa,se] - dia_asignado[pa,se-1] - separacion[pa,se]);

% El desvio entre sesiones no debe exceder el desvio maximo
var int: max_desvio; % Desvio maximo
constraint forall(pa in PACIENTE, se in 2..s)(abs(desvio[pa,se]) <= max_desvio);

% Objetivo: Minimizar el desvio maximo
solve minimize max_desvio;