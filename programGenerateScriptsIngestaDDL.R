library(dplyr)
library(stringr)
library(readxl)

#PATH
setwd("C:/Users/jcman/Downloads/Dichter/DichterPrueba")
files <- list.files(path = "data/")
nameFile <- "Datos.xlsx"
nameFileScript <- "script-ddl-encuesta.sql"

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
  
  #validamos que el script exista
  if (file.exists(paste(as.character(getwd()),"\\scriptDB\\",nameFileScript , sep = ""))) {
    #Delete file if it exists
    file.remove(paste(as.character(getwd()),"\\scriptDB\\",nameFileScript, sep = ""))
  }
  
  #recorriendo el df para generar los INSERT de la tabla en la DB SQLServers
  for(row in 1:nrow(dfEncuestas)) {
    
    SubjectID <- dfEncuestas[row, "SubjectID"]
    DPEncargado <- dfEncuestas[row, "DPEncargado"]
    EstadoTicket <- dfEncuestas[row, "EstadoTicket"]
    JobId <- dfEncuestas[row, "JobId"]
    IdPropuesta <- dfEncuestas[row, "IdPropuesta"]
    Gerente <- dfEncuestas[row, "Gerente"]
    Muestra <- dfEncuestas[row, "Muestra"]
    PaisDeEjecucion <- dfEncuestas[row, "PaisDeEjecucion"]
    PaisDeVenta <- dfEncuestas[row, "PaisDeVenta"]
    TipoDeEstudio <- dfEncuestas[row, "TipoDeEstudio"]
    Tecnica <- dfEncuestas[row, "Tecnica"]
    Plataforma <- dfEncuestas[row, "Plataforma"]
    
    FechaInicioEstimada <- dfEncuestas[row, "FechaInicioEstimada"]
    FechaInicioEstimada <- as.POSIXct(strptime(FechaInicioEstimada, format="%Y-%m-%d %H:%M:%S", tz="UTC"))
    
    FechaFinEstimada <- dfEncuestas[row, "FechaFinEstimada"]
    FechaFinEstimada <- as.POSIXct(strptime(FechaFinEstimada, format="%Y-%m-%d %H:%M:%S", tz="UTC"))
    
    Programa <- dfEncuestas[row, "Programa"]
    Entrevistador <- dfEncuestas[row, "Entrevistador"]
    
    DiaDeCarga <- dfEncuestas[row, "DiaDeCarga"]
    DiaDeCarga <- as.POSIXct(strptime(DiaDeCarga, format="%Y-%m-%d %H:%M:%S", tz="UTC"))
    
    Dia <- dfEncuestas[row, "Dia"]
    Mes <- dfEncuestas[row, "Mes"]
    Ano <- dfEncuestas[row, "Ano"]
    EstatusEncuesta <- dfEncuestas[row, "EstatusEncuesta"]
    Test <- dfEncuestas[row, "Test"]
    
    VisitStart <- dfEncuestas[row, "VisitStart"]
    VisitStart <- as.POSIXct(strptime(VisitStart, format="%Y-%m-%d %H:%M:%S", tz="UTC"))
    
    VisitEnd <- dfEncuestas[row, "VisitEnd"]
    VisitEnd <- as.POSIXct(strptime(VisitEnd, format="%Y-%m-%d %H:%M:%S", tz="UTC"))
    
    QualityControlFlag <- ifelse(is.null(dfEncuestas[row, "QualityControlFlag"]), "NULL", paste("'",dfEncuestas[row, "QualityControlFlag"],"'"))
    
    IsFiltered <- dfEncuestas[row, "IsFiltered"]
    Cancelada <- dfEncuestas[row, "Cancelada"]
    Expirada <- dfEncuestas[row, "Expirada"]
    Validadas <- dfEncuestas[row, "Validadas"]
    GPSValidation <- dfEncuestas[row, "GPSValidation"]
    Descartadas <- dfEncuestas[row, "Descartadas"]
    
    ClientDuration <- ifelse(is.null(dfEncuestas[row, "ClientDuration"]), "NULL", paste("'",as.POSIXct(strptime(dfEncuestas[row, "ClientDuration"], format="%H:%M:%S", tz="UTC")),"'"))
    
    TiempoEntreEncuesta <- dfEncuestas[row, "TiempoEntreEncuesta"]
    DuracionMinutos <- dfEncuestas[row, "DuracionMinutos"]
    IncidenciaFiltro <- dfEncuestas[row, "IncidenciaFiltro"]
    
    CuentasClave <- ifelse(is.null(dfEncuestas[row, "CuentasClave"]), "NULL", paste("'",str_trim(str_trim(dfEncuestas[row, "CuentasClave"],"right"),"left"),"'"))
    
    ScriptSQL <- paste("INSERT INTO Encuesta(SubjectID,DPEncargado,EstadoTicket,JobId,IdPropuesta,Gerente,Muestra,PaisDeEjecucion,PaisDeVenta,TipoDeEstudio,Tecnica,Plataforma,FechaInicioEstimada,FechaFinEstimada,Programa,Entrevistador,DiaDeCarga,Dia,Mes,Ano,EstatusEncuesta,Test,VisitStart,VisitEnd,QualityControlFlag,IsFiltered,Cancelada,Expirada,Validadas,GPSValidation,Descartadas,ClientDuration,TiempoEntreEncuesta,DuracionMinutos,IncidenciaFiltro,CuentasClave)VALUES(",SubjectID,",'",DPEncargado,"','",EstadoTicket,"','",JobId,"',",IdPropuesta,",'",Gerente,"',",Muestra,",'",PaisDeEjecucion,"','",PaisDeVenta,"','",TipoDeEstudio,"','",Tecnica,"','",Plataforma,"','",FechaInicioEstimada,"','",FechaFinEstimada,"','",Programa,"','",Entrevistador,"','",DiaDeCarga,"',",Dia,",",Mes,",",Ano,",'",EstatusEncuesta,"','",Test,"','",VisitStart,"','",VisitEnd,"',",QualityControlFlag,",'",IsFiltered,"','",Cancelada,"','",Expirada,"','",Validadas,"','",GPSValidation,"','",Descartadas,"','",ClientDuration,"',",TiempoEntreEncuesta,",",DuracionMinutos,",",IncidenciaFiltro,",",CuentasClave,");", sep = "")
    cat(as.character(ScriptSQL), file=paste(as.character(getwd()),"\\scriptDB\\",nameFileScript, sep = ""), sep="\n", append=TRUE)
    
  }
  
}

View(dfEncuestas)