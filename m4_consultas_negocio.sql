--MOTOR: PostgreSQL 18-- 

--Consulta 1 — Resumen ejecutivo mensual--

SELECT 

EXTRACT (MONTH FROM fecha_venta) AS mes,
SUM (cantidad*precio_unitario) AS total_facturado,
COUNT (id_venta) AS cantidad_ventas,
ROUND (AVG (cantidad*precio_unitario),2) AS promedio_ticket 
--uso round para q no me salgan tantos ceros en el ticket promedio--

FROM ventas

GROUP BY
EXTRACT (MONTH FROM fecha_venta)

ORDER BY 
mes;

--Consulta 2 — Ranking de productos--

SELECT 
id_producto,
SUM (cantidad) AS unidades_vendidas,
SUM (cantidad*precio_unitario) AS total_generado

FROM
ventas

GROUP BY 
id_producto
ORDER BY
total_generado DESC
LIMIT 5;

--Consulta 3 — Clientes recurrentes--

SELECT 
id_cliente,
COUNT (*) AS cantidad_pedidos,
SUM (cantidad*precio_unitario) AS total_gastado

FROM 
ventas
GROUP BY
id_cliente
HAVING COUNT(*) > 1;

--Consulta 4 — Meses por encima/por debajo del promedio--

WITH ventas AS(
SELECT
EXTRACT (MONTH FROM fecha_venta) AS mes,
SUM (cantidad*precio_unitario) AS total_facturado
FROM ventas
GROUP BY EXTRACT (MONTH FROM fecha_venta)
)

SELECT
mes,
total_facturado,
CASE 
WHEN total_facturado >= (SELECT AVG (total_facturado) FROM ventas) 
THEN 'Por encima'
ELSE 'Por debajo'
END AS situacion_promedio

FROM 
ventas
ORDER BY
mes;

/*
me genera únicamente del mes de marzo pero corresponde a que
todas las ventas cargadas en la base corresponden a ese mes.

Pruebo con SELECT para ver que todas las ventas correspondan a marzo
*/

SELECT 
fecha_venta
FROM ventas

/*
--BLOQUE DE CIERRE--

1- Con respecto a la segunda consulta, puedo determinar que el producto 1 genera 
más del 50% de la facturación con 3 unidades vendidas.

2- Con respecto a la consulta 3, se concluye que los cinco clientes registrados
hicieron 2 pedidos cada uno, siendo el cliente 1 el que más gastó con $2.640 y el 
cliente 4 el que menos gastó con $510.

3- En la cuarta consulta, se observa que el total facturado durante el mes de marzo
fue de $6.444 y está por encima del promedio (aunque al haber solo ventas del
mes de marzo en la base de datos no puedo compararlo con otros meses). 

*/

