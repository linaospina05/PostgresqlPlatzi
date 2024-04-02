'Script para entregar la primera fila'
SELECT *
FROM platzi.alumnos
FETCH FIRST 1 ROWS ONLY;

SELECT *
FROM platzi.alumnos
LIMIT 1;

'Traer los alumnos junto con un row number'

SELECT *
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, * 
	FROM platzi.alumnos
)AS alumnos_with_row_num
;

'Filtrar una fila especifica'

SELECT *
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, * 
	FROM platzi.alumnos
)AS alumnos_with_row_num	
WHERE row_id = 1;

'Reto: Filtrar los primeros 5 registros de la tabla'
'Forma 1'
SELECT *
FROM platzi.alumnos
FETCH FIRST 5 ROWS ONLY;
 
'Forma 2'
SELECT *
FROM platzi.alumnos
LIMIT 5;

'Forma 3'
SELECT *
FROM (
	SELECT ROW_NUMBER() OVER() AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row_num
WHERE row_id <=5
;

'Ejemplo uso Distint:trae solo una vez'
SELECT DISTINCT colegiatura
FROM platzi.alumnos AS a1
WHERE 2 = (
	SELECT COUNT (DISTINCT colegiatura)
	FROM platzi.alumnos a2
	WHERE a1.colegiatura <= a2.colegiatura
);


'Segunda colegiatura más alta'
SELECT DISTINCT colegiatura
FROM platzi.alumnos
ORDER BY colegiatura DESC
LIMIT 1 OFFSET 1;

''
SELECT DISTINCT colegiatura,tutor_id
FROM platzi.alumnos
WHERE tutor_id = 20
ORDER BY colegiatura DESC
LIMIT 1 OFFSET 1;

'Ejemplo inner join; Segunda mayor colegiatura'
SELECT *
FROM platzi.alumnos AS datos_alumnos
INNER JOIN(
	SELECT DISTINCT colegiatura
	FROM platzi.alumnos
	WHERE tutor_id = 20
	ORDER BY colegiatura DESC
	LIMIT 1 OFFSET 1
)AS segunda_mayor_colegiatura
ON datos_alumnos.colegiatura = segunda_mayor_colegiatura.colegiatura;

'Ejemplo'

SELECT *
FROM platzi.alumnos AS datos_alumnos
WHERE colegiatura = (
	SELECT DISTINCT colegiatura
	FROM platzi.alumnos
	WHERE tutor_id = 20
	ORDER BY colegiatura DESC
	LIMIT 1 OFFSET 1
);

'Ejercicio traer la segunda mitad de la tabla'
SELECT * 
FROM platzi.alumnos 
OFFSET ( SELECT (COUNT(id)/2) FROM platzi.alumnos )


'Solucion reto propuesta por tutor'
SELECT ROW_NUMBER() OVER() AS row_id, *
FROM platzi.alumnos
OFFSET(
	SELECT COUNT(*)/2
	FROM platzi.alumnos
);



'Seleccionar un set de opciones'
SELECT *
FROM(
	SELECT ROW_NUMBER() OVER() AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row_num

'Para elegir filas especificas'
SELECT *
FROM(
	SELECT ROW_NUMBER() OVER() AS row_id, * 'Subquery'
	FROM platzi.alumnos
) AS alumnos_with_row_num
WHERE row_id IN (1,5,10,12,15,20);

'Elegir filas especificas de otra manera'
SELECT *
FROM platzi.alumnos
WHERE id IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
);

'Otra forma de elegir filas filtrando un valor especifico para una de las columnas'

SELECT id, tutor_id 'Qué parámetro se va a llamar'
	FROM platzi.alumnos 'a que tabla pertenecen los datos'
	WHERE tutor_id = 30; 'que condicion debe cumplir los datos que se van a llamar'

'Ejemplo de uso de subquery: Se usan para agregar condiciones'
SELECT *
FROM platzi.alumnos
WHERE id IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
	AND carrera_id =31
);

'Reto: Seleccionar los resultados que no se encuentren en el set anterior'
SELECT *
FROM platzi.alumnos
WHERE id NOT IN (
	SELECT id
	FROM platzi.alumnos
	WHERE tutor_id = 30
	AND carrera_id =31
);


'TIEMPOS'
'Algunos desarrolladores manejan las fechas y horas como cadenas. Sin embargo, es importante conocer las funciones de fecha en sql.'

SELECT EXTRACT(YEAR FROM fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;


'Trae una parte de una fecha'
SELECT DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;


SELECT DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion,
	DATE_PART('MONTH', fecha_incorporacion) AS mes_incorporacion,
	DATE_PART('DAY', fecha_incorporacion) AS dia_incorporacion
FROM platzi.alumnos;

'Reto: sacar los datos de la hora'
SELECT DATE_PART('HOUR', fecha_incorporacion) AS hora_incorporacion,
	DATE_PART('MINUTE', fecha_incorporacion) AS minuto_incorporacion,
	DATE_PART('SECOND', fecha_incorporacion) AS segundo_incorporacion
FROM platzi.alumnos;


'Uso de Extract como filtro'
SELECT *
FROM platzi.alumnos
WHERE ( EXTRACT( YEAR FROM fecha_incorporacion)) =2019;

'Uso de Date_part como filtro'
SELECT *
FROM platzi.alumnos
WHERE(DATE_PART('YEAR', fecha_incorporacion)) = 2019;


'Para agregar una columna o claisficacion de unos datos seleccionados'
SELECT *
FROM (
	SELECT *,
		DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion
	FROM platzi.alumnos
) AS alumnos_con_anio;


'Para un filtrar un campo en especifico'
SELECT *
FROM (
	SELECT *,
		DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion
	FROM platzi.alumnos
) AS alumnos_con_anio
WHERE anio_incorporacion = 2020;

'Reto: Extraer alumnos incorporados en mayo de 2018'
'Solución emplenado Date_part'
SELECT *
FROM platzi.alumnos
WHERE(DATE_PART('YEAR', fecha_incorporacion)) = 2018
AND (DATE_PART('MONTH', fecha_incorporacion)) = 05


'Solución empleando Extract'
SELECT *
    FROM platzi.alumnos
    WHERE (EXTRACT(YEAR FROM fecha_incorporacion)) = 2018
        AND (EXTRACT(MONTH FROM fecha_incorporacion)) = 05;

'Ultima opción y la más extensa'
SELECT *
FROM (
	SELECT *,
		DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion,
		DATE_PART('MONTH', fecha_incorporacion) AS mes_incorporacion
	FROM platzi.alumnos
) AS alumnos_con_anio
WHERE anio_incorporacion = 2018 AND mes_incorporacion = 05;

'Duplicados'
'Ejercicio de insercción de dato duplicado'
insert into platzi.alumnos (id, nombre, apellido, email, colegiatura, fecha_incorporacion, carrera_id, tutor_id) values (1001, 'Pamelina', null, 'pmylchreestrr@salon.com', 4800, '2020-04-26 10:18:51', 12, 16);

'Ahora, como encontrar registros duplicados cuando sabemos que la duplicidad está en el ID'
SELECT *
FROM platzi.alumnos AS ou
WHERE ( 
	SELECT COUNT (*)
	FROM platzi.alumnos AS inr
	WHERE ou.id = inr.id
) >1;

'Otra manera de encontrar data duplicada'
SELECT(platzi.alumnos.*)::text, COUNT(*)
FROM platzi.alumnos
GROUP BY platzi.alumnos.*
HAVING COUNT(*) > 1;

'Para asegurarse que se están comparando cada uno de los datos en la tabla sin contar el ID'
SELECT(
	platzi.alumnos.nombre,
	platzi.alumnos.apellido,
	platzi.alumnos.email,	
	platzi.alumnos.colegiatura,	
	platzi.alumnos.fecha_incorporacion,
	platzi.alumnos.carrera_id,
	platzi.alumnos.tutor_id
	)::text, COUNT(*)
FROM platzi.alumnos
GROUP BY platzi.alumnos.nombre,
	platzi.alumnos.apellido,
	platzi.alumnos.email,	
	platzi.alumnos.colegiatura,	
	platzi.alumnos.fecha_incorporacion,
	platzi.alumnos.carrera_id,
	platzi.alumnos.tutor_id
HAVING COUNT(*) > 1;

'Usando un subquery'
SELECT *
FROM (
	SELECT id,
	ROW_NUMBER() OVER(
		PARTITION BY
		nombre,
		apellido,
		email,
		colegiatura,
		fecha_incorporacion,
		carrera_id,
		tutor_id
	ORDER BY id ASC
	) AS row,
	*
	FROM platzi.alumnos
) AS duplicados
WHERE duplicados.row > 1;


'Reto: Borrar el dato duplicado'
DELETE
FROM platzi.alumnos
WHERE id IN(
SELECT id
FROM(
	SELECT id,
	ROW_NUMBER() OVER(
		PARTITION BY
		nombre,
		apellido,
		email,
		colegiatura,
		fecha_incorporacion,
		carrera_id,
		tutor_id
	ORDER BY id ASC
	) AS row
	FROM platzi.alumnos
) AS duplicados
WHERE duplicados.row > 1);


'Selectores de rango'
'Seleccionar datos especificos'
SELECT *
FROM platzi.alumnos
WHERE tutor_id IN (1,2,3,4);

'Seleccionar un rango'
SELECT *
FROM platzi.alumnos
WHERE tutor_id >= 1 
	AND tutor_id <= 10;

'Uso de Between'
SELECT *
FROM platzi.alumnos
WHERE tutor_id BETWEEN 1 AND 10;

'Ejemplo de range'
SELECT int4range(10,20) @>3; 'Averiguar si un dato está dentro de un rango'


'Si se solapan algunos de los valores en ambos rangos'
SELECT numrange(11.1,22.2) && numrange(20.0,30.0); 

'upper'
SELECT UPPER (int8range(15,25));

'lower'
SELECT LOWER (int8range(15,25));

'Duevuelve la intersección de los números en común'
SELECT int4range(10,20)* int4range(15,25);

'Si el rango está vacío'
SELECT ISEMPTY (numrange(1,5));


'Ejemplo de range con la base de datos'
SELECT *
FROM platzi.alumnos
WHERE int4range(10,20) @> tutor_id;

'Reto: Valores en comun de ID tutor y ID  carrera'
SELECT int4range(MIN(tutor_id),MAX(tutor_id)) * int4range (MIN(carrera_id),MAX(carrera_id))
FROM platzi.alumnos;

'Opción del profesor'
SELECT numrange(
	(SELECT MIN(tutor_id) FROM platzi.alumnos),
	(SELECT MAX(tutor_id) FROM platzi.alumnos)
) * numrange(
	(SELECT MIN(carrera_id) FROM platzi.alumnos),
	(SELECT MAX(carrera_id) FROM platzi.alumnos)
);		   

'Máximos'

SELECT fecha_incorporacion
FROM platzi.alumnos
ORDER BY fecha_incorporacion DESC
LIMIT 1;

'Range ordenado'
SELECT carrera_id, 
	MAX(fecha_incorporacion)
FROM platzi.alumnos
GROUP BY carrera_id
ORDER BY carrera_id;

'Reto: Esteblecer el minimo por Id de tutor y nombre alfabeticamente que existe en la tabla'
SELECT tutor_id, 
	MIN(nombre)
FROM platzi.alumnos
GROUP BY tutor_id
ORDER BY tutor_id;


'Self join'
SELECT a.nombre,
	   a.apellido,
	   t.nombre,
	   t.apellido
FROM platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t ON a.tutor_id=t.id;
	

'CONCAT'
SELECT CONCAT(a.nombre, '', a.apellido) AS alumno,
	   CONCAT(t.nombre, '', t.apellido) AS tutor
FROM   platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t ON a.tutor_id=t.id;	   
	   

'Ejercicio conocer cuantos alumnos tiene cada tutor '
SELECT 
	   CONCAT(t.nombre, '', t.apellido) AS tutor,
	   COUNT(*) AS alumnos_por_tutor
FROM   platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t ON a.tutor_id=t.id
GROUP BY tutor
ORDER BY alumnos_por_tutor DESC;	

'Ejercicio conocer cuales son los 10 tutores con más alumnos'
SELECT 
	   CONCAT(t.nombre, '', t.apellido) AS tutor,
	   COUNT(*) AS alumnos_por_tutor
FROM   platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t ON a.tutor_id=t.id
GROUP BY tutor
ORDER BY alumnos_por_tutor DESC
LIMIT 10;	
	   
'Promedio de alumnos por tutor'
SELECT AVG(conteo.alumnos_por_tutor) AS promedio_alumnos
FROM(SELECT CONCAT(t.nombre, ' ', t.apellido) AS tutor, 
	COUNT(*) AS alumnos_por_tutor 
	FROM platzi.alumnos AS a INNER JOIN platzi.alumnos AS t ON (a.tutor_id = t.id)
	GROUP BY tutor) AS conteo
;


'Otra forma de solucionarlo'
SELECT AVG(alumnos_por_tutor) AS promedio_alumnos_por_tutor
FROM(
SELECT 
	   CONCAT(t.nombre, '', t.apellido) AS tutor,
	   COUNT(*) AS alumnos_por_tutor
FROM   platzi.alumnos AS a
	INNER JOIN platzi.alumnos AS t ON a.tutor_id=t.id
GROUP BY tutor
) AS alumnos_tutor;

'Alumnos por carrera'
SELECT carrera_id, COUNT(*) AS cuenta
FROM platzi.alumnos
GROUP BY carrera_id 
ORDER BY cuenta DESC;

'Recordar estrucura:
1. Qué parámetro voy a llamar
2. De qué tabla tomaré los datos
3. Cómo se va a deiscriminar esa información'

'Ejemplo borrar un rango de una tabla'
DELETE FROM platzi.carreras
WHERE id BETWEEN 30 AND 40;


'Ejemplo de left join esclusive'

'El siguiente script de SQL realiza una consulta utilizando un LEFT JOIN para obtener datos de dos tablas, alumnos y carreras, en una base de datos llamada platzi. Luego, filtra los resultados para mostrar solo aquellos registros en los que no existe una coincidencia en la tabla de carreras (es decir, aquellos registros en alumnos que no tienen una carrera asociada).

Aquí está el desglose de la consulta:

SELECT: Selecciona las columnas que se mostrarán en los resultados de la consulta.

a.nombre, a.apellido, a.carrera_id: Estas son las columnas seleccionadas de la tabla alumnos.
c.id, c.carrera: Estas son las columnas seleccionadas de la tabla carreras.
FROM: Especifica las tablas de las que se van a obtener los datos.

platzi.alumnos AS a: Especifica que se está seleccionando de la tabla alumnos, y se le asigna el alias a.
platzi.carreras AS c: Especifica que se está seleccionando de la tabla carreras, y se le asigna el alias c.
LEFT JOIN: Une las filas de la tabla alumnos con las filas correspondientes de la tabla carreras basándose en la igualdad de los valores en la columna carrera_id de alumnos y la columna id de carreras. Un LEFT JOIN devuelve todas las filas de la tabla de la izquierda (alumnos en este caso) y las filas correspondientes de la tabla de la derecha (carreras). Si no hay correspondencia en la tabla de la derecha, se devuelven NULL para las columnas de la tabla de la derecha.

ON: Especifica la condición de unión entre las dos tablas.

a.carrera_id = c.id: Indica que se unirán las filas donde el valor de carrera_id en la tabla alumnos sea igual al valor de id en la tabla carreras.
WHERE: Filtra las filas después de la unión.

c.id IS NULL: Filtra los resultados para incluir solo aquellas filas donde no hay una coincidencia en la tabla de carreras, es decir, donde id es NULL en la tabla carreras.
ORDER BY: Ordena los resultados de la consulta.

a.carrera_id: Ordena los resultados según el campo carrera_id de la tabla alumnos.
En resumen, esta consulta devuelve los nombres, apellidos y IDs de carrera de los alumnos que no tienen una carrera asociada en la tabla carreras, ordenados por su carrera_id.
'
SELECT  a.nombre,
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a
	LEFT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
WHERE c.id IS NULL
ORDER BY a.carrera_id;

'Reto Full Outer Join'
SELECT  a.nombre,
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a
	FULL OUTER JOIN platzi.carreras AS c
	ON a.carrera_id = c.id
ORDER BY a.carrera_id;

'Ejemplo clase uniones // Diagramas de Venn'
'Estructura: Parámetros, tabla y condicones.'

'Left join'
SELECT  a.nombre,
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a
	LEFT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id;

'Left join exclusive'
SELECT  a.nombre, 
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a 
	LEFT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id 
WHERE c.id IS NULL;	


'Right join'
SELECT  a.nombre, 
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a 
	RIGHT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id 
ORDER BY c.id DESC;	


'RIGHT JOIN  EXCLUSIVE'
SELECT  a.nombre, 
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a 
	RIGHT JOIN platzi.carreras AS c
	ON a.carrera_id = c.id 
WHERE a.id IS NULL
ORDER BY c.id DESC;	


'DATOS que existen en ambas tablas: intersección o INNER JOIN'
SELECT  a.nombre, 
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a 
	INNER JOIN platzi.carreras AS c
	ON a.carrera_id = c.id 
ORDER BY c.id DESC;	

'FULL OUTER: DIFERENCIA SIMETRICA'
SELECT  a.nombre, 
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a 
	FULL OUTER JOIN platzi.carreras AS c
	ON a.carrera_id = c.id 
ORDER BY c.id DESC;


'FULL OUTER exclusive: DIFERENCIA SIMETRICA'
SELECT  a.nombre, 
		a.apellido,
		a.carrera_id,
		c.id,
		c.carrera
FROM platzi.alumnos AS a 
	FULL OUTER JOIN platzi.carreras AS c
	ON a.carrera_id = c.id 
WHERE a.id IS NULL
	OR c.id IS NULL
ORDER BY a.carrera_id DESC, c.id DESC;	

'Clase triangulando'
'left padding: agregar relleno a la izquierda'
SELECT lpad('sql', 15,'*');

'Añadir caracteres segun el espacio de ID'
SELECT lpad('sql', id,'*')
FROM platzi.alumnos
WHERE id < 10;


SELECT lpad('*', id,'*')
FROM platzi.alumnos
WHERE id < 10;

'Rellenar espacio izquierdo'
SELECT lpad('437',5,'0') 

'Rellenar espacio derecho'
SELECT rpad('437',5,'0') 

'Ejemplo lpad'
SELECT lpad('*', CAST (row_id AS int), '*')
FROM (
	SELECT ROW_NUMBER() OVER(ORDER BY carrera_id) AS row_id, *
	FROM platzi.alumnos
) AS alumnos_with_row_id
WHERE row_id <=5
ORDER BY carrera_id;

'Clase: Generación de rangos'
'Estrucura de generate_series: (No. de inicio, No. final,patron de la serie)'
SELECT *
FROM generate_series(3,4);

SELECT *
FROM generate_series(4,4);

SELECT *
FROM generate_series(3,4,-1);

SELECT *
FROM generate_series(1.1,4,1.3);

'Usar fecha actual y sumar no de días en la tupla'
SELECT current_date + s.a AS dates
FROM generate_series(0,14,7) AS s(a);

'Ejemplo aumentar horas a partir de una fecha'
SELECT *
FROM generate_series ('2020-09-01 00:00:00'::timestamp,
					  '2020-09-04 12:00:00', '10 hours');

'Forma práctica de generate_series, ejemplo alumnos que tienen un id entre 1-10'
SELECT a.id,
	a.nombre,
	a.apellido,
	a.carrera_id,
	s.a
FROM platzi.alumnos AS a
	INNER JOIN generate_series(0,10) AS s(a)
	ON s.a = a.carrera_id
ORDER BY a.carrera_id


'Reto'
SELECT lpad('*',CAST(ordinality AS int), '*')
FROM generate_series(10,2,-2) WITH ordinality;

'Expresiones regulares'

'Filtrar emails de acuerdo al patron establecido'
SELECT email 
FROM platzi.alumnos
WHERE email ~*'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}';

'Emails filtrados por google'
SELECT email 
FROM platzi.alumnos
WHERE email ~*'[A-Z0-9._%+-]+@google[A-Z0-9.-]+\.[A-Z]{2,4}';

'window functions'
SELECT *,
	AVG(colegiatura) OVER (PARTITION BY carrera_id)
FROM platzi.alumnos;	
----
SELECT*,
	RANK() OVER( PARTITION BY carrera_id ORDER BY colegiatura DESC)
FROM platzi.alumnos;	
---
SELECT *
FROM(
	SELECT *,
	RANK() OVER( PARTITION BY carrera_id ORDER BY colegiatura DESC) AS brand_rank
	FROM platzi.alumnos
) AS rnaked_colegiaturas_por_carrera	
WHERE brand_rank < 3
ORDER BY brand_rank;

'Más de windows functions: Particiones y agregaciones'
'Row_Number'
SELECT ROW_NUMBER() OVER(ORDER BY fecha_incorporacion) AS row_id, *
FROM platzi.alumnos;

'First value'
SELECT FIRST_VALUE(colegiatura) OVER() AS row_id, *
FROM platzi.alumnos;

'PARTITON BY'
SELECT FIRST_VALUE(colegiatura) OVER(PARTITION BY carrera_id) AS row_id, *
FROM platzi.alumnos;

'Last Value'
SELECT LAST_VALUE(colegiatura) OVER(PARTITION BY carrera_id) AS ultima_colegiatura, *
FROM platzi.alumnos;

'Valores enesimos'
SELECT NTH_VALUE(colegiatura,3) OVER(PARTITION BY carrera_id) AS ultima_colegiatura, *
FROM platzi.alumnos;

'Rank'
SELECT*,
	RANK() OVER( PARTITION BY carrera_id ORDER BY colegiatura DESC) AS colegiatura_rank
FROM platzi.alumnos
ORDER BY carrera_id,colegiatura_rank;

'Dense_rank'
SELECT*,
	DENSE_RANK() OVER( PARTITION BY carrera_id ORDER BY colegiatura DESC) AS colegiatura_rank
FROM platzi.alumnos
ORDER BY carrera_id,colegiatura_rank;

'PERCENT_RANK'
SELECT*,
	PERCENT_RANK() OVER( PARTITION BY carrera_id ORDER BY colegiatura DESC) AS colegiatura_rank
FROM platzi.alumnos
ORDER BY carrera_id,colegiatura_rank;


