# DichterPrueba Juan Carlos Manotas
En el Archivo de Datos tenemos la información de las últimas 30mil encuestas realizadas en la
compañía, a las cuales queremos calcularle ciertos indicadores para saber la calidad de esta y
estos indicadores deben ser generados y provistos por un stored procedure en la base de
datos, mínimo con la siguiente información:
- Insumo 1: Agrupado por Mes año, Eje y cálculo del indicador.
- Insumo 2: País ejecución, Indicadores
- Insumo 3: De acuerdo a los siguientes puntos retornar la información mínima
requerida a continuación.
Todos los indicadores que abajo se detallan deben ser calculados a nivel de Entrevistador y
luego promediar a nivel de País de ejecución para que se puedan crear las visualizaciones ya
descritas.
Indicador GPS:
Las encuestas con GPS valido son las que en la variable GPSValidation viene con un “1” y el
indicador para esta debe ser calculado de la siguiente forma:
- GPSValidation = 1 / Descartadas = 0 * 100
Indicador Expiradas:
Para este indicador debemos calcular utilizando las variables Expirada y Validadas y la
ecuación es la siguiente:
- (1-(Expirada = 1 / Validada = 1))*100

Canceladas:
Para este indicador debemos calcular utilizando las variables Cancelada y Validadas y la
ecuación es la siguiente:
- (1-(Cancelada = 1 / Validada = 1))*100

Calidad
Este indicador es el resultado de los tres indicadores ya descritos y lo que haremos es
dependiendo la nota obtenida en cada indicador le asignaremos un peso a cada nota y este
posteriormente sumara la nota de calidad, a continuación, detallo los pesos:

<p align="left">
  <img src="https://github.com/jcmanotas/DichterPrueba/img/imagen01.png" title="">
</p>

<p align="left">
  <img src="https://github.com/jcmanotas/DichterPrueba/img/imagen02.png" title="">
</p>

Para el caso de las canceladas si el Entrevistador ya tiene una encuesta cancelada tendrá un
peso de 0 automáticamente tal como detalla el siguiente cuadro, de lo contrario obtendrá
50%:

<p align="left">
  <img src="https://github.com/jcmanotas/DichterPrueba/img/imagen03.png" title="">
</p>

Entregables:
- Creación de base de datos en SQL Server, script de los objetos para ser ejecutados en la
base de datos utilizada para la prueba.
- Creación de una ETL para cargar la información del archivo en una tabla de la base de
datos creada, tener presente que cada vez que se ejecute la ETL se debe verificar que, si
existe información en la tabla, se borren todos los datos y se vuelva a cargar todos los
datos del archivo de la prueba.
- Se debe tener la información de cada uno de los indicadores almacenadas en tablas, las
cuales se deben llenar cuando se ejecute el procesamiento de la información, el
procesamiento de la información debe ser un procedimiento almacenado que al ser
ejecutado valide que, si ya existe información en los insumos solicitados, estos datos sean
borrados.
- Creación de un SP que, mediante un parámetro de entrada, permita retornar la
información solicitada en los insumos mencionados al comienzo de la prueba, ya que este
va a ser ejecutado a futuro por un front para visualizar los datos al cliente.
- Elaborar un diagrama AS-IS/TO-BE del ejercicio realizado, teniendo en cuenta que el AS-IS
corresponde a descargar la información de un sistema externo de un proveedor que
capturas las encuestas, esta información se guarda en un recurso compartido o FTP en
formato Excel y el área de proyectos todos los días se conecta al repositorio y procesa de
forma manual lo mencionado en la prueba, generando en el Excel varias Hojas con los
indicadores seleccionados; el TO-BE, es la automatización de este proceso leyendo
mediante una ETL de un recurso compartido o FTP el archivo que el proveedor genera en
Excel, la ETL carga automáticamente el archivo a la base de datos y mediante un JOB que
se programa el procesamiento de la información varias veces al día, dejando los datos en
varias tablas, para que un navegador tome estos datos mediante un SP y se visualicen al
cliente con los cálculos mencionados en la prueba antes descrita.

