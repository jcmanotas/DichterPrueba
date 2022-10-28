/*
Indicador GPS:
GPSValidation = 1 / Descartadas = 0 * 100
*/
SELECT
GPSValidation.IdPropuesta,
ROUND(((CAST(GPSValidation.vrGPSValidation AS FLOAT) / CAST(Descartadas.vrDescartada AS FLOAT)) * 100.0 ),0) AS INDICADOR_GPS
FROM
(
SELECT IdPropuesta, GPSValidation,
COUNT(*) AS vrGPSValidation
FROM [dbo].[Encuesta]
WHERE GPSValidation = 1
GROUP BY GPSValidation, IdPropuesta
) AS GPSValidation
INNER JOIN
(
SELECT IdPropuesta, Descartadas,
COUNT(*) AS vrDescartada
FROM [dbo].[Encuesta] A
WHERE Descartadas = 0
GROUP BY Descartadas, IdPropuesta
) AS Descartadas ON(GPSValidation.IdPropuesta=Descartadas.IdPropuesta)


/*
Indicador Expiradas:
(1-(Expirada = 1 / Validada = 1))*100
*/
SELECT
Validadas.IdPropuesta,
ROUND(((1-(CAST(Expiradas.vrExpirada AS FLOAT) / CAST(Validadas.vrValidada AS FLOAT))) * 100.0 ), 0) AS INDICADOR_EXPIRADA
FROM
(
SELECT IdPropuesta, Expirada,
COUNT(*) AS vrExpirada
FROM [dbo].[Encuesta]
WHERE Expirada = 1
GROUP BY Expirada, IdPropuesta
) AS Expiradas
INNER JOIN
(
SELECT IdPropuesta, Validadas,
COUNT(*) AS vrValidada
FROM [dbo].[Encuesta] A
WHERE Validadas = 1
GROUP BY Validadas, IdPropuesta
) AS Validadas ON(Expiradas.IdPropuesta=Validadas.IdPropuesta)


/*
Canceladas:
(1-(Cancelada = 1 / Validada = 1))*100
*/

SELECT
Validadas.IdPropuesta,
ROUND(((1-(CAST(Canceladas.vrCancelada AS FLOAT) / CAST(Validadas.vrValidada AS FLOAT))) * 100.0 ), 0) AS INDICADOR_CANCELADAS
FROM
(
SELECT IdPropuesta, Cancelada,
COUNT(*) AS vrCancelada
FROM [dbo].[Encuesta]
WHERE Cancelada = 1
GROUP BY Cancelada, IdPropuesta
) AS Canceladas
INNER JOIN
(
SELECT IdPropuesta, Validadas,
COUNT(*) AS vrValidada
FROM [dbo].[Encuesta]
WHERE Validadas = 1
GROUP BY Validadas, IdPropuesta
) AS Validadas ON(Canceladas.IdPropuesta=Validadas.IdPropuesta)



/*
ENCUESTADOR
*/
SELECT
IdPropuesta,
Entrevistador,
COUNT(*) AS CANT,
SUM(Cancelada) AS CANCELADA
FROM [dbo].[Encuesta] A WHERE 1=1
                            AND IdPropuesta=1841
GROUP BY Entrevistador, IdPropuesta HAVING SUM(Cancelada)>0

/*ENTREVISTADOR PRUEBA*/
SELECT
IdPropuesta,
Entrevistador,
COUNT(*) AS CANT,
SUM(Cancelada) AS CANCELADAS
FROM [dbo].[Encuesta] A WHERE 1=1 AND IdPropuesta=1841
GROUP BY IdPropuesta, Entrevistador
HAVING SUM(Cancelada)>0


