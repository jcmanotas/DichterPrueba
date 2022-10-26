/*
Script Creado por: Juan Carlos Manotas C
Correo: jmanotas@gmail.com
*/
USE dbencuesta;
/*
CREATE TABLE [dbo].[Encuesta];
TRUNCATE TABLE [dbo].[Encuesta];
SELECT * FROM [dbo].[Encuesta];
*/
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Encuesta' and xtype='U')
    CREATE TABLE [dbo].[Encuesta]
    (
        SubjectID INT IDENTITY(42300342,1) NOT NULL PRIMARY KEY,
        DPEncargado VARCHAR(12) NOT NULL,
        EstadoTicket VARCHAR(16) NOT NULL,
        JobId VARCHAR(18) NOT NULL,
        IdPropuesta INT NOT NULL,
        Gerente VARCHAR(36) NOT NULL,
        Muestra INT NOT NULL,
        PaisDeEjecucion VARCHAR(20) NOT NULL,
        PaisDeVenta VARCHAR(20) NOT NULL,
        TipoDeEstudio VARCHAR(16) NOT NULL,
        Tecnica VARCHAR(10) NOT NULL,
        Plataforma VARCHAR(3) NOT NULL,
        FechaInicioEstimada DATETIME NOT NULL,
        FechaFinEstimada DATETIME NOT NULL,
        Programa VARCHAR(64) NOT NULL,
        Entrevistador VARCHAR(36) NOT NULL,
        DiaDeCarga DATETIME NOT NULL,
        Dia INT NOT NULL,
        Mes INT NOT NULL,
        Ano INT NOT NULL,
        EstatusEncuesta VARCHAR(20) NOT NULL,
        Test BIT NOT NULL,
        VisitStart DATETIME NOT NULL,
        VisitEnd DATETIME NOT NULL,
        QualityControlFlag VARCHAR(12) NULL,
        IsFiltered BIT NOT NULL,
        Cancelada BIT NOT NULL,
        Expirada BIT NOT NULL,
        Validadas BIT NOT NULL,
        GPSValidation BIT NOT NULL,
        Descartadas BIT NOT NULL,
        ClientDuration TIME NOT NULL,
        TiempoEntreEncuesta INT NOT NULL,
        DuracionMinutos INT NOT NULL,
        IncidenciaFiltro INT NOT NULL,
        CuentasClave VARCHAR(32) NULL
    )
GO

/*
CREA CHECK PARA VALIDAR EL DPEncargado
*/
ALTER TABLE [dbo].[Encuesta] ADD CONSTRAINT chkDPEncargado CHECK (DPEncargado IN('DP Colombia','DP Panamá'));
/*
CREA CHECK PARA VALIDAR EL EstadoTicket
*/
ALTER TABLE [dbo].[Encuesta] ADD CONSTRAINT chkEstadoTicket CHECK (EstadoTicket IN('04. Programación','07. Producción','09. Limpieza','12. Codificación','13. Cálculos','16. Completado'));
/*
CREA CHECK PARA VALIDAR EL Tecnica
*/
ALTER TABLE [dbo].[Encuesta] ADD CONSTRAINT chkTecnica CHECK (Tecnica IN('CAPI','CATI','CATI NI','PAPI-STG','StoreView'));
/*
CREA CHECK PARA VALIDAR EL Plataforma
*/
ALTER TABLE [dbo].[Encuesta] ADD CONSTRAINT chkPlataforma CHECK (Plataforma IN('STG'));
/*
CREA CHECK PARA VALIDAR EL Dia
*/
ALTER TABLE [dbo].[Encuesta] ADD CONSTRAINT chkDia CHECK (Dia >=1 and Dia <=31);
/*
CREA CHECK PARA VALIDAR EL Mes
*/
ALTER TABLE [dbo].[Encuesta] ADD CONSTRAINT chkMes CHECK (Mes >=1 and Mes <=12);
/*
CREA CHECK PARA VALIDAR EL Ano
*/
ALTER TABLE [dbo].[Encuesta] ADD CONSTRAINT chkAno CHECK (Ano IN(2016,2017));
/*
CREA CHECK PARA VALIDAR EL EstatusEncuesta
*/
ALTER TABLE [dbo].[Encuesta] ADD CONSTRAINT chkEstatusEncuesta CHECK (EstatusEncuesta IN('Approved','Canceled','Expired','In progress (Office)','In Progress (Other)','Initially Approved','Requires Approval','Surveyor Handling','Unassigned Surveyor','Visible In Reports'));
