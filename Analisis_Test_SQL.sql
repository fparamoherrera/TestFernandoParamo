--Test DeAcero
-- Fernando Paramo
--20/06/2025
USE BDDEACEROQA

/*Proporcionar el Query que me traiga el precio del nodo (pml) en MDA y el precio en MTR del nodo 01ANS-85, 
ordenado por nodo (ascendente) , por fecha (descente) y ascendente por hora*/
SELECT 
    'MDA' AS origen,
    claNodo,
    fecha,
    hora,
    pml
FROM MemSch.MeMTRaMDADet
WHERE claNodo = '01ANS-85'

UNION ALL

SELECT 
    'MTR' AS origen,
    claNodo,
    fecha,
    hora,
    pml
FROM MemSch.MeMTRaMTRDet
WHERE claNodo = '01ANS-85'

ORDER BY claNodo ASC, fecha DESC, hora ASC;


/*
Proporciona el Query que me traiga el precio promedio por nodo en MTR y en MDA, 
y la diferencia de estos 2 precios promedio, ordenado por diferencia descedentemente
*/

SELECT 
    MDA.claNodo,
    MTR.avg_pml AS Promedio_MTR,
    MDA.avg_pml AS Promedio_MDA,
    MTR.avg_pml - MDA.avg_pml AS Diferencia
FROM (
    SELECT claNodo, AVG(pml) AS avg_pml
    FROM MemSch.MeMTRaMDADet
    GROUP BY claNodo
) MDA
INNER JOIN (
    SELECT claNodo, AVG(pml) AS avg_pml
    FROM MemSch.MeMTRaMTRDet
    GROUP BY claNodo
) MTR ON MDA.claNodo = MTR.claNodo
ORDER BY Diferencia DESC;

/*
Proporciona el precio de nodo en dlls tomando como tipo de cambio el campo valor que esta en la tabla MEMTRaTcDet
*/
SELECT 
    MDA.claNodo,
    MDA.fecha,
    MDA.hora,
    MDA.pml AS pml_mxn,
    TC.valor AS tipo_cambio,
    ROUND(MDA.pml / TC.valor, 4) AS pml_usd
FROM MemSch.MeMTRaMDADet MDA
JOIN MemSch.MeMTRaTcDet TC ON MDA.fecha = TC.fecha
ORDER BY MDA.fecha DESC, MDA.hora ASC;

/*
Proporciona el listado de nodos por fecha, hora, de los precios de los nodos en MDA y MTR, 
junto con el tipo de cambio y el precio de la tbfin
*/
SELECT 
    MDA.claNodo,
    MDA.fecha,
    MDA.hora,
    MDA.pml AS pml_MDA,
    MTR.pml AS pml_MTR,
    TC.valor AS tipo_cambio,
    TB.TbFin
FROM MemSch.MeMTRaMDADet MDA
JOIN MemSch.MeMTRaMTRDet MTR 
    ON MDA.claNodo = MTR.claNodo 
    AND MDA.fecha = MTR.fecha 
    AND MDA.hora = MTR.hora
JOIN MemSch.MeMTRaTcDet TC 
    ON MDA.fecha = TC.fecha
JOIN MemSch.MeMTRaTBFinVw TB 
    ON MDA.fecha = TB.fecha
ORDER BY MDA.claNodo ASC, 
MDA.fecha DESC, 
MDA.hora ASC;

