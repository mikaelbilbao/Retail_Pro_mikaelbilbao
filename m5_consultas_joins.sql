--MOTOR: PostgreSQL 18-- 

-- Consulta 1 — Vista base del proyecto (INNER JOIN)

SELECT 
v.id_venta,
v.fecha_venta,
c.id_cliente,
c.nombre AS nombre_cliente,
c.ciudad,
p.id_producto,
p.nombre_producto,
cat.nombre_categoria,
v.cantidad,
v.precio_unitario,
(v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c 
ON v.id_cliente = c.id_cliente
INNER JOIN productos p 
ON v.id_producto = p.id_producto
INNER JOIN categorias cat 
ON p.id_categoria = cat.id_categoria
ORDER BY 
v.fecha_venta ASC;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)


SELECT 
c.nombre,
c.email,
c.fecha_registro
FROM clientes c
LEFT JOIN ventas v 
ON c.id_cliente = v.id_cliente
WHERE 
v.id_venta IS NULL;

--Consulta 3 -  Productos sin ventas (LEFT JOIN) 


SELECT
p.nombre_producto,
cat.nombre_categoria,
p.precio
FROM productos p
INNER JOIN categorias cat
ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
ON p.id_producto = v.id_producto
WHERE 
v.id_venta IS NULL;

--Consulta 4 - Consolidado por canal (UNION ALL)


SELECT
canal,
COUNT(*) AS cantidad_ventas,
SUM(total) AS total_canal
FROM (
--Ventas financiadas (en cuotas)
SELECT 
fecha_venta, 
cantidad * precio_unitario AS total, 
'Financiado' AS canal
FROM ventas 
WHERE id_venta IN (1, 2, 3, 4, 5)
    
UNION ALL
    
--Ventas en efectivo
SELECT 
fecha_venta, 
cantidad * precio_unitario AS total, 
'Efectivo' AS canal
FROM ventas 
WHERE id_venta IN (6, 7, 8, 9, 10)
) AS consolidado
GROUP BY 
canal
ORDER BY 
total_canal DESC;



