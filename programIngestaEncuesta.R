library(dplyr)
library(stringr)
library(readxl)

library(odbc)
con <- dbConnect(odbc(), Driver = "SQL Server", Server = "localhost", Database = "dbencuesta", UID = "sa", PWD = "Calidad2020*-", Port = 1433)

#PATH
setwd("C:/Users/jcman/Downloads/Dichter/DichterPrueba")
files <- list.files(path = "data/")
nameFile <- "Datos.xlsx"
tableName <- "Encuesta"

#validamos que la tabla exista
if (dbExistsTable(con, tableName)){
  #dbRemoveTable(con, "temp_tickers")
  
  #cargamos el archivo de excel
  #Cargado el Archivo de Encuestas con Nombre=Datos.xlsx
  for (i in 1:length(files)) {
    if(files[i]==nameFile){
      dfEncuestas <- read_xlsx(path = paste0(getwd(),"/data/",files[i]), sheet = "Hoja1")
    }
  }
  
  #Validamos que el df venga lleno
  if(nrow(dfEncuestas)>0){
    #cambiamos el nombre de las columnas del dataframe
    colnames(dfEncuestas) <- c('SubjectID','DPEncargado','EstadoTicket','JobId','IdPropuesta','Gerente','Muestra','PaisDeEjecucion','PaisDeVenta','TipoDeEstudio','Tecnica','Plataforma','FechaInicioEstimada','FechaFinEstimada','Programa','Entrevistador','DiaDeCarga','Dia','Mes','Ano','EstatusEncuesta','Test','VisitStart','VisitEnd','QualityControlFlag','IsFiltered','Cancelada','Expirada','Validadas','GPSValidation','Descartadas','ClientDuration','TiempoEntreEncuesta','DuracionMinutos','IncidenciaFiltro','CuentasClave')
    
    dfEncuestas <- dfEncuestas %>%
      mutate(FechaInicioEstimada = as.POSIXct(strptime(FechaInicioEstimada, format="%Y-%m-%d %H:%M:%S", tz="UTC"))) %>%
      mutate(FechaFinEstimada = as.POSIXct(strptime(FechaFinEstimada, format="%Y-%m-%d %H:%M:%S", tz="UTC"))) %>%
      mutate(DiaDeCarga = as.POSIXct(strptime(DiaDeCarga, format="%Y-%m-%d %H:%M:%S", tz="UTC"))) %>%
      mutate(VisitStart = as.POSIXct(strptime(VisitStart, format="%Y-%m-%d %H:%M:%S", tz="UTC"))) %>%
      mutate(VisitEnd = as.POSIXct(strptime(VisitEnd, format="%Y-%m-%d %H:%M:%S", tz="UTC"))) %>%
      mutate(ClientDuration = as.POSIXct(strptime(ClientDuration, format="%Y-%m-%d %H:%M:%S", tz="UTC"))) %>%
      mutate(CuentasClave = str_trim(str_trim(CuentasClave,"right"),"left"))
    
    #View(dfEncuestas)
    #escribimos en la tabla luego de leer el archivo de excel
    dbWriteTable(con, DBI::SQL("dbo.Encuesta"), value = dfEncuestas, overwrite = TRUE)
  }
}

#liberamos recursos
dbDisconnect(con)