
USE dbencuesta;
GO
CREATE PROCEDURE getIndicadoresEncuestas
AS
    SET NOCOUNT ON;

    SELECT * FROM (SELECT A.IdPropuesta,
                      A.Entrevistador,
                      C.INDICADOR_GPS,
                      CASE
                          WHEN C.INDICADOR_GPS >= 0 AND C.INDICADOR_GPS <= 69 THEN 0
                          WHEN C.INDICADOR_GPS >= 70 AND C.INDICADOR_GPS <= 89 THEN (C.INDICADOR_GPS-70) + 1
                          WHEN C.INDICADOR_GPS >= 90 AND C.INDICADOR_GPS <= 100 THEN 25
                          ELSE 0 END AS NOTA_INDICADOR_GPS,
                      B.INDICADOR_EXPIRADA,
                      CASE
                          WHEN B.INDICADOR_EXPIRADA >= 0 AND B.INDICADOR_EXPIRADA <= 84 THEN 0
                          WHEN B.INDICADOR_EXPIRADA >= 85 AND B.INDICADOR_EXPIRADA <= 100 THEN ((B.INDICADOR_EXPIRADA-85) + 1) * 1575
                          ELSE 0 END AS NOTA_INDICADOR_EXPIRADA,
                      A.INDICADOR_CANCELADAS,
                      CASE
                          WHEN A.vrCancelada > 0 THEN 0 ELSE 50 END AS NOTA_INDICADOR_CANCELADA

               FROM (SELECT Validadas.IdPropuesta,
                            ENTREVISTADOR.Entrevistador,
                            ENTREVISTADOR.vrCancelada,
                            ROUND(((1 -
                                    (CAST(ENTREVISTADOR.vrCancelada AS FLOAT) / CAST(Validadas.vrValidada AS FLOAT))) *
                                   100.0), 0) AS INDICADOR_CANCELADAS
                     FROM (SELECT IdPropuesta,
                                  Entrevistador,
                                  SUM(Cancelada) AS vrCancelada
                           FROM [dbo].[Encuesta] A
                           GROUP BY IdPropuesta, Entrevistador) AS ENTREVISTADOR
                              INNER JOIN
                          (SELECT IdPropuesta,
                                  Entrevistador,
                                  COUNT(*) AS vrValidada
                           FROM [dbo].[Encuesta] A
                           WHERE Validadas = 1
                           GROUP BY IdPropuesta, Entrevistador) AS Validadas
                          ON (ENTREVISTADOR.IdPropuesta = Validadas.IdPropuesta and
                              ENTREVISTADOR.Entrevistador = Validadas.Entrevistador)


                    ) AS A
                        INNER JOIN
                    (SELECT Validadas.IdPropuesta,
                            Validadas.Entrevistador,
                            ROUND(((1 - (CAST(Expiradas.vrExpirada AS FLOAT) / CAST(Validadas.vrValidada AS FLOAT))) *
                                   100.0), 0) AS INDICADOR_EXPIRADA
                     FROM (SELECT IdPropuesta,
                                  Entrevistador,
                                  COUNT(*) AS vrExpirada
                           FROM [dbo].[Encuesta]
                           WHERE Expirada = 1
                           GROUP BY IdPropuesta, Entrevistador) AS Expiradas
                              INNER JOIN
                          (SELECT IdPropuesta,
                                  Entrevistador,
                                  COUNT(*) AS vrValidada
                           FROM [dbo].[Encuesta] A
                           WHERE Validadas = 1
                           GROUP BY IdPropuesta, Entrevistador) AS Validadas
                          ON (Expiradas.IdPropuesta = Validadas.IdPropuesta AND
                              Expiradas.Entrevistador = Validadas.Entrevistador)) AS B
                    ON (A.IdPropuesta = B.IdPropuesta AND A.Entrevistador = B.Entrevistador)

                        INNER JOIN
                    (SELECT GPSValidation.IdPropuesta,
                            GPSValidation.Entrevistador,
                            ROUND(((CAST(GPSValidation.vrGPSValidation AS FLOAT) /
                                    CAST(Descartadas.vrDescartada AS FLOAT)) * 100.0), 0) AS INDICADOR_GPS
                     FROM (SELECT IdPropuesta,
                                  Entrevistador,
                                  COUNT(*) AS vrGPSValidation
                           FROM [dbo].[Encuesta]
                           WHERE GPSValidation = 1
                           GROUP BY IdPropuesta, Entrevistador) AS GPSValidation
                              INNER JOIN
                          (SELECT IdPropuesta,
                                  Entrevistador,
                                  COUNT(*) AS vrDescartada
                           FROM [dbo].[Encuesta] A
                           WHERE Descartadas = 0
                           GROUP BY IdPropuesta, Entrevistador) AS Descartadas
                          ON (GPSValidation.IdPropuesta = Descartadas.IdPropuesta AND
                              GPSValidation.Entrevistador = Descartadas.Entrevistador)) AS C
                    ON (B.IdPropuesta = C.IdPropuesta AND B.Entrevistador = C.Entrevistador)) D;

GO
