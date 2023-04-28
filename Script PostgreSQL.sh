#!/bin/bash

#Práctica 1
#Bash Script para PostgreSQL


NOMBRE_BD="alumnopostgre"
NOMBRE_USUARIO="alumno"
NOMBRE_PROFESOR="profesor"
PASSWORD="bd22223"

## --  Descarga datos necesarios del repositorio. 
# Descarga los archivos CSV
# Oferta y ocupación de plazas-2019,2020,2021
wget https://zaguan.unizar.es/record/87665/files/CSV.csv -O 87665.csv
wget https://zaguan.unizar.es/record/96835/files/CSV.csv -O 96835.csv
wget https://zaguan.unizar.es/record/108270/files/CSV.csv -O 108270.csv

# Resultados de las titulaciones-2019,2020,2021
wget https://zaguan.unizar.es/record/95644/files/CSV.csv -O 95644.csv
wget https://zaguan.unizar.es/record/107369/files/CSV.csv -O 107369.csv
wget https://zaguan.unizar.es/record/118234/files/CSV.csv -O 118234.csv

# Notas de corte definitivas del cupo general a estudios de grados-2019,2020,2021
wget https://zaguan.unizar.es/record/87663/files/CSV.csv -O 87663.csv
wget https://zaguan.unizar.es/record/98173/files/CSV.csv -O 98173.csv
wget https://zaguan.unizar.es/record/109322/files/CSV.csv -O 109322.csv

# Acuerdos de movilidad de estudiantes ERASMUS y SICUE-2019,2020,2021
wget https://zaguan.unizar.es/record/83980/files/CSV.csv -O 83980.csv
wget https://zaguan.unizar.es/record/95648/files/CSV.csv -O 95648.csv
wget https://zaguan.unizar.es/record/107373/files/CSV.csv -O 107373.csv

# Alumnos egresados por titulación-2019,2020,2021
wget https://zaguan.unizar.es/record/95646/files/CSV.csv -O 95646.csv
wget https://zaguan.unizar.es/record/107371/files/CSV.csv -O 107371.csv
wget https://zaguan.unizar.es/record/118236/files/CSV.csv -O 118236.csv

# Rendimiento por asignatura y titulación-2019,2020,2021
wget https://zaguan.unizar.es/record/95645/files/CSV.csv -O 95645.csv
wget https://zaguan.unizar.es/record/107370/files/CSV.csv -O 107370.csv
wget https://zaguan.unizar.es/record/118235/files/CSV.csv -O 118235.csv

echo "Datos descargados del repositorio."

## -- Crear usuario y BD.
# Verifica si el usuario y la BD ya existen, si existen elimina los anteriores
sudo -u postgres psql -c "DROP DATABASE IF EXISTS $NOMBRE_BD;"
sudo -u postgres psql -c "DROP USER IF EXISTS $NOMBRE_USUARIO;"
echo "Si existía un usuario y base de datos con el mismo nombre, se han eliminado."

# Crea un usuario
sudo -u postgres psql -c "CREATE USER $NOMBRE_USUARIO WITH PASSWORD '$PASSWORD';"


# Crea una base de datos
sudo -u postgres psql -c "CREATE DATABASE ${NOMBRE_BD} WITH OWNER $NOMBRE_USUARIO;"

echo "La base de datos se ha creado."


## -- Crea las tablas para cada archivo CSV,(tablas temporales).
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_oferta_ocupacion (
   CURSO_ACADEMICO varchar,
   ESTUDIO varchar,
   LOCALIDAD varchar,
   CENTRO varchar,
   TIPO_CENTRO varchar,
   TIPO_ESTUDIO varchar,
   PLAZAS_OFERTADAS varchar,
   PLAZAS_MATRICULADAS varchar,
   PLAZAS_SOLICITADAS varchar,
   INDICE_OCUPACION varchar,
   FECHA_ACTUALIZACION varchar
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_resultados_titulaciones (
   CURSO_ACADEMICO varchar,
   CENTRO varchar,
   ESTUDIO varchar,
   TIPO_ESTUDIO varchar,
   ALUMNOS_MATRICULADOS varchar,
   ALUMNOS_NUEVO_INGRESO varchar,
   PLAZAS_OFERTADAS varchar,
   ALUMNOS_GRADUADOS varchar,
   ALUMNOS_ADAPTA_GRADO_MATRI varchar,
   ALUMNOS_ADAPTA_GRADO_MATRI_NI varchar,
   ALUMNOS_ADAPTA_GRADO_TITULADO varchar,
   ALUMNOS_CON_RECONOCIMIENTO varchar,
   ALUMNOS_MOVILIDAD_ENTRADA varchar,
   ALUMNOS_MOVILIDAD_SALIDA varchar,
   CREDITOS_MATRICULADOS varchar,
   CREDITOS_RECONOCIDOS varchar,
   DURACION_MEDIA_GRADUADOS varchar,
   TASA_EXITO varchar,
   TASA_RENDIMIENTO varchar,
   TASA_EFICIENCIA varchar,
   TASA_ABANDONO varchar,
   TASA_GRADUACION varchar,
   FECHA_ACTUALIZACION varchar
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_notas_corte (
   CURSO_ACADEMICO varchar,
   ESTUDIO varchar,
   LOCALIDAD varchar,
   CENTRO varchar,
   PRELA_CONVO_NOTA_DEF varchar,
   NOTA_CORTE_DEFINITIVA_JULIO varchar,
   NOTA_CORTE_DEFINITIVA_SEPTIEMBRE varchar,
   FECHA_ACTUALIZACION varchar
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_acuerdos_movilidad (
   CURSO_ACADEMICO varchar,
   NOMBRE_PROGRAMA_MOVILIDAD varchar,
   NOMBRE_AREA_ESTUDIOS_MOV varchar,
   CENTRO varchar,
   IN_OUT varchar,
   NOMBRE_IDIOMA_NIVEL_MOVILIDAD varchar,
   PAIS_UNIVERSIDAD_ACUERDO varchar,
   UNIVERSIDAD_ACUERDO varchar,
   PLAZAS_OFERTADAS_ALUMNOS varchar,
   PLAZAS_ASIGNADAS_ALUMNOS_OUT varchar,
   FECHA_ACTUALIZACION varchar
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_alumnos_egresados_titulacion (
   CURSO_ACADEMICO varchar,
   LOCALIDAD varchar,
   ESTUDIO varchar,
   TIPO_ESTUDIO varchar,
   TIPO_EGRESO varchar,
   SEXO varchar,
   ALUMNOS_GRADUADOS varchar,
   ALUMNOS_INTERRUMPEN_ESTUDIOS varchar,
   ALUMNOS_INTERRUMPEN_EST_ANO1 varchar,
   ALUMNOS_TRASLADAN_OTRA_UNIV varchar,
   DURACION_MEDIA_GRADUADOS varchar,
   TASA_EFICIENCIA varchar,
   FECHA_ACTUALIZACION varchar
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_rendimiento_asignatura_titulacion (
   CURSO_ACADEMICO varchar,
   TIPO_ESTUDIO varchar,
   ESTUDIO varchar,
   LOCALIDAD varchar,
   CENTRO varchar,
   ASIGNATURA varchar,
   TIPO_ASIGNATURA varchar,
   CLASE_ASIGNATURA varchar,
   TASA_EXITO varchar,
   TASA_RENDIMIENTO varchar,
   TASA_EVALUACION varchar,
   ALUMNOS_EVALUADOS varchar,
   ALUMNOS_SUPERADOS varchar,
   ALUMNOS_PRESENTADOS varchar,
   MEDIA_CONVOCATORIAS_CONSUMIDAS varchar,
   FECHA_ACTUALIZACION varchar
);"

#Crea una tabla por cada csv, según su contenido correspondiente a las tablas creadas anteriormente
# Oferta y ocupación de plazas
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_oferta_ocupacion_2019 (LIKE tabla_oferta_ocupacion);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_oferta_ocupacion_2020 (LIKE tabla_oferta_ocupacion);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_oferta_ocupacion_2021 (LIKE tabla_oferta_ocupacion);"

# Resultados de las titulaciones
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_resultados_titulaciones_2019 (LIKE tabla_resultados_titulaciones);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_resultados_titulaciones_2020 (LIKE tabla_resultados_titulaciones);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_resultados_titulaciones_2021 (LIKE tabla_resultados_titulaciones);"

# Notas de corte definitivas del cupo general a estudios de grados
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_notas_corte_2019 (LIKE tabla_notas_corte);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_notas_corte_2020 (LIKE tabla_notas_corte);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_notas_corte_2021 (LIKE tabla_notas_corte);"

# Acuerdos de movilidad de estudiantes ERASMUS y SICUE
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_acuerdos_movilidad_2019 (LIKE tabla_acuerdos_movilidad);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_acuerdos_movilidad_2020 (LIKE tabla_acuerdos_movilidad);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_acuerdos_movilidad_2021 (LIKE tabla_acuerdos_movilidad);"

# Alumnos egresados por titulación
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_alumnos_egresados_titulacion_2019 (LIKE tabla_alumnos_egresados_titulacion);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_alumnos_egresados_titulacion_2020 (LIKE tabla_alumnos_egresados_titulacion);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_alumnos_egresados_titulacion_2021 (LIKE tabla_alumnos_egresados_titulacion);"

# Rendimiento por asignatura y titulación
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_rendimiento_asignatura_titulacion_2019 (LIKE tabla_rendimiento_asignatura_titulacion);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_rendimiento_asignatura_titulacion_2020 (LIKE tabla_rendimiento_asignatura_titulacion);"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE tabla_rendimiento_asignatura_titulacion_2021 (LIKE tabla_rendimiento_asignatura_titulacion);"


#--Carga los datos en la tabla
# Oferta y ocupación de plazas-2019,2020,2021
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_oferta_ocupacion_2019 FROM './87665.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_oferta_ocupacion_2020 FROM './96835.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_oferta_ocupacion_2021 FROM './108270.csv' DELIMITER ';' CSV HEADER;"

# Resultados de las titulaciones-2019,2020,2021
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_resultados_titulaciones_2019 FROM './95644.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_resultados_titulaciones_2020 FROM './107369.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_resultados_titulaciones_2021 FROM './118234.csv' DELIMITER ';' CSV HEADER;"

# Notas de corte definitivas del cupo general a estudios de grados-2019,2020,2021
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_notas_corte_2019 FROM './87663.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_notas_corte_2020 FROM './98173.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_notas_corte_2021 FROM './109322.csv' DELIMITER ';' CSV HEADER;"

# Acuerdos de movilidad de estudiantes ERASMUS y SICUE-2019,2020,2021
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_acuerdos_movilidad_2019 FROM './83980.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_acuerdos_movilidad_2020 FROM './95648.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_acuerdos_movilidad_2021 FROM './107373.csv' DELIMITER ';' CSV HEADER;"

# Alumnos egresados por titulación-2019,2020,2021
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_alumnos_egresados_titulacion_2019 FROM './95646.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_alumnos_egresados_titulacion_2020 FROM './107371.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_alumnos_egresados_titulacion_2021 FROM './118236.csv' DELIMITER ';' CSV HEADER;"

# Rendimiento por asignatura y titulación-2019,2020,2021
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_rendimiento_asignatura_titulacion_2019 FROM './95645.csv' DELIMITER ';' CSV HEADER;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_rendimiento_asignatura_titulacion_2020 FROM './107370.csv' DELIMITER ';' CSV HEADER;"
#psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "\copy tabla_rendimiento_asignatura_titulacion_2021 FROM './118235.csv' DELIMITER ';' CSV HEADER;"
#No se ha cargado el año 2021, porque en el fichero csv hay un error con una fila.


echo "Datos importados en las tablas temporales";

## -- Procesa e importa los datos descargados
# Crear las tablas según el diseño E/R 
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE centro (
   id_centro SERIAL PRIMARY KEY,
   nombre_centro varchar,
   tipo_centro varchar,
   localidad varchar(255)
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE estudios (
   id_estudio SERIAL PRIMARY KEY,
   nombre_estudio varchar,
   id_centro int,
   FOREIGN KEY (id_centro) REFERENCES centro(id_centro)
   
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE estudio_anyo (
	id_estudio_anyo SERIAL PRIMARY KEY,
	curso_academico int,
   	nota_corte_definitiva_julio double precision,
   	nota_corte_definitiva_septiembre double precision,
   	plazas_ofertadas int,
   	plazas_matriculadas int,
   	indice_ocupacion double precision,
   	id_estudio int, 
   	FOREIGN KEY (id_estudio) REFERENCES estudios(id_estudio)
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE convenio_movilidad (
   id_convenio_movilidad SERIAL PRIMARY KEY,
   nombre_idioma_nivel_movilidad varchar,
   universidad_acuerdo varchar,
   pais_universidad_acuerdo varchar,
   plazas_asignadas_alumnos_out int,
   in_out varchar,
   nombre_programa_movilidad varchar,
   id_centro int,
   FOREIGN KEY (id_centro) REFERENCES centro(id_centro)
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE resultado (
   id_resultado SERIAL PRIMARY KEY,
   duracion_media_graduados double precision,
   alumnos_graduados int,
   alumnos_con_reconocimiento int,
   alumnos_nuevo_ingreso int,
   creditos_matriculados double precision,
   creditos_reconocidos double precision,
   alumnos_matriculados int,
   tasa_rendimiento double precision,
   tasa_exito double precision,
   id_estudio int,
   FOREIGN KEY (id_estudio) REFERENCES estudios(id_estudio)
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE asignatura (
	id_asignatura SERIAL PRIMARY KEY,
   	nombre_asignatura varchar,
   	tipo_asignatura varchar,
   	clase_asignatura varchar,
   	id_estudio int,
  	FOREIGN KEY (id_estudio) REFERENCES estudios(id_estudio)
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE asignatura_anyo (
   id_asignatura_anyo SERIAL PRIMARY KEY,
   alumnos_evaluados int,
   alumnos_superados int,
   alumnos_presentados int,
   media_convocatorias_consumidas double precision,
   id_asignatura int,
   FOREIGN KEY (id_asignatura) REFERENCES asignatura(id_asignatura) 	
);"

echo "Tablas creadas"

## -- Filtra por estudios de grado y en los csv de rendimiento por asignatura y titulación filtra por grados de EINA y EUPT.

# Estudio de grados
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_oferta_ocupacion_2019 
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_oferta_ocupacion_2020
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_oferta_ocupacion_2021
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_resultados_titulaciones_2019
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_resultados_titulaciones_2020
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_resultados_titulaciones_2021
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_alumnos_egresados_titulacion_2019
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_alumnos_egresados_titulacion_2020
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_alumnos_egresados_titulacion_2021
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_rendimiento_asignatura_titulacion_2019
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_rendimiento_asignatura_titulacion_2020
   WHERE tipo_estudio != 'Grado';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_rendimiento_asignatura_titulacion_2021
   WHERE tipo_estudio != 'Grado';"

# Rendimiento por asignatura y titulación por grados de EINA y EUPT.
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_rendimiento_asignatura_titulacion_2019
   WHERE centro != 'Escuela de Ingeniería y Arquitectura'
   and centro != 'Escuela Universitaria Politécnica de Teruel';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_rendimiento_asignatura_titulacion_2020
   WHERE centro != 'Escuela de Ingeniería y Arquitectura'
   and centro != 'Escuela Universitaria Politécnica de Teruel';"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DELETE FROM tabla_rendimiento_asignatura_titulacion_2021
   WHERE centro != 'Escuela de Ingeniería y Arquitectura'
   and centro != 'Escuela Universitaria Politécnica de Teruel';"
   
echo "Filtración realizada"

## --Cargar los datos en las tablas creadas según el diseño E/R.
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "INSERT INTO centro(nombre_centro, tipo_centro, localidad)
	SELECT DISTINCT nombre_centro, tipo_centro, localidad
	FROM (
			SELECT oferta19.centro AS nombre_centro, oferta19.tipo_centro AS tipo_centro, oferta19.localidad AS localidad
			FROM tabla_oferta_ocupacion_2019 AS oferta19
			UNION ALL
			SELECT oferta20.centro AS nombre_centro, oferta20.tipo_centro AS tipo_centro, oferta20.localidad AS localidad
			FROM tabla_oferta_ocupacion_2020 AS oferta20
			UNION ALL
			SELECT oferta21.centro AS nombre_centro, oferta21.tipo_centro AS tipo_centro, oferta21.localidad AS localidad
			FROM tabla_oferta_ocupacion_2021 AS oferta21
	) AS sub_centro;"	
	
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "INSERT INTO estudios(nombre_estudio, id_centro)
	SELECT DISTINCT nombre_estudio, id_centro
	FROM (
			SELECT ofertaoc19.estudio AS nombre_estudio, 
				cast(c.id_centro as int) AS id_centro
			FROM tabla_oferta_ocupacion_2019 ofertaoc19, centro AS c
			WHERE c.nombre_centro = ofertaoc19.centro
			UNION ALL
			SELECT ofertaoc20.estudio AS nombre_estudio, 
				cast(c.id_centro as int) AS id_centro
			FROM tabla_oferta_ocupacion_2020 ofertaoc20, centro AS c
			WHERE c.nombre_centro = ofertaoc20.centro
			UNION ALL
			SELECT ofertaoc21.estudio AS nombre_estudio, 
				cast(c.id_centro as int) AS id_centro
			FROM tabla_oferta_ocupacion_2021 ofertaoc21, centro AS c
			WHERE c.nombre_centro = ofertaoc21.centro
	) AS sub_estudios;"
	
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "INSERT INTO estudio_anyo (curso_academico, nota_corte_definitiva_julio,
   	nota_corte_definitiva_septiembre, plazas_ofertadas, plazas_matriculadas, indice_ocupacion, id_estudio)
   	SELECT DISTINCT curso_academico, nota_corte_definitiva_julio,
   		nota_corte_definitiva_septiembre, plazas_ofertadas, plazas_matriculadas, indice_ocupacion, id_estudio 
   	FROM (
   			SELECT cast(notasc19.curso_academico as int) AS curso_academico,
   			 	cast(notasc19.nota_corte_definitiva_julio as double precision) AS nota_corte_definitiva_julio,
   				cast(notasc19.nota_corte_definitiva_septiembre as double precision) AS nota_corte_definitiva_septiembre, 
   				cast(oferta19.plazas_ofertadas as int) AS plazas_ofertadas, 
   				cast(oferta19.plazas_matriculadas as int) AS plazas_matriculadas, 
   				cast(oferta19.indice_ocupacion as double precision) AS indice_ocupacion,
   				cast(e.id_estudio as int) AS id_estudio
   			FROM tabla_notas_corte_2019 AS notasc19, tabla_oferta_ocupacion_2019 AS oferta19, estudios AS e, centro AS c
   			WHERE c.nombre_centro = oferta19.centro and e.nombre_estudio = oferta19.estudio
   				and e.id_centro = c.id_centro and notasc19.centro = oferta19.centro 
   				and notasc19.estudio = oferta19.estudio
   				and e.id_estudio = id_estudio	
   			UNION ALL
   			SELECT cast(notasc20.curso_academico as int) AS curso_academico,
   			 	cast(notasc20.nota_corte_definitiva_julio as double precision) AS nota_corte_definitiva_julio,
   				cast(notasc20.nota_corte_definitiva_septiembre as double precision) AS nota_corte_definitiva_septiembre, 
   				cast(oferta20.plazas_ofertadas as int) AS plazas_ofertadas, 
   				cast(oferta20.plazas_matriculadas as int) AS plazas_matriculadas, 
   				cast(oferta20.indice_ocupacion as double precision) AS indice_ocupacion,
   				cast(e.id_estudio as int) AS id_estudio
   			FROM tabla_notas_corte_2020 AS notasc20, tabla_oferta_ocupacion_2020 AS oferta20, estudios AS e, centro AS c
   			WHERE c.nombre_centro = oferta20.centro and e.nombre_estudio = oferta20.estudio
   				and e.id_centro = c.id_centro and notasc20.centro = oferta20.centro 
   				and notasc20.estudio = oferta20.estudio
   				and e.id_estudio = id_estudio	
   			UNION ALL
   			SELECT cast(notasc21.curso_academico as int) AS curso_academico,
   			 	cast(notasc21.nota_corte_definitiva_julio as double precision) AS nota_corte_definitiva_julio,
   				cast(notasc21.nota_corte_definitiva_septiembre as double precision) AS nota_corte_definitiva_septiembre, 
   				cast(oferta21.plazas_ofertadas as int) AS plazas_ofertadas, 
   				cast(oferta21.plazas_matriculadas as int) AS plazas_matriculadas, 
   				cast(oferta21.indice_ocupacion as double precision) AS indice_ocupacion,
   				cast(e.id_estudio as int) AS id_estudio
   			FROM tabla_notas_corte_2021 AS notasc21, tabla_oferta_ocupacion_2021 AS oferta21, estudios AS e, centro AS c
   			WHERE c.nombre_centro = oferta21.centro and e.nombre_estudio = oferta21.estudio
   				and e.id_centro = c.id_centro and notasc21.centro = oferta21.centro 
   				and notasc21.estudio = oferta21.estudio
   				and e.id_estudio = id_estudio		
   	) AS sub_estudio_anyo;"	

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "INSERT INTO convenio_movilidad (nombre_idioma_nivel_movilidad, universidad_acuerdo,
   pais_universidad_acuerdo, plazas_asignadas_alumnos_out, in_out, nombre_programa_movilidad, id_centro)
   SELECT nombre_idioma_nivel_movilidad, universidad_acuerdo,
   		pais_universidad_acuerdo, plazas_asignadas_alumnos_out, in_out, nombre_programa_movilidad, id_centro
   FROM (
   			SELECT acuerdosm19.nombre_idioma_nivel_movilidad AS nombre_idioma_nivel_movilidad, 
   				acuerdosm19.universidad_acuerdo AS universidad_acuerdo,
   				acuerdosm19.pais_universidad_acuerdo AS pais_universidad_acuerdo, 
   				cast(acuerdosm19.plazas_asignadas_alumnos_out as int) AS plazas_asignadas_alumnos_out, 
   				acuerdosm19.in_out AS in_out, 
   				acuerdosm19.nombre_programa_movilidad AS nombre_programa_movilidad,
   				c.id_centro AS id_centro
   			FROM tabla_acuerdos_movilidad_2019 AS acuerdosm19, centro AS c
   			WHERE acuerdosm19.in_out = 'OUT' and c.nombre_centro = acuerdosm19.centro
   			UNION ALL
   			SELECT acuerdosm20.nombre_idioma_nivel_movilidad AS nombre_idioma_nivel_movilidad, 
   				acuerdosm20.universidad_acuerdo AS universidad_acuerdo,
   				acuerdosm20.pais_universidad_acuerdo AS pais_universidad_acuerdo, 
   				cast(acuerdosm20.plazas_asignadas_alumnos_out as int) AS plazas_asignadas_alumnos_out, 
   				acuerdosm20.in_out AS in_out, 
   				acuerdosm20.nombre_programa_movilidad AS nombre_programa_movilidad,
   				c.id_centro AS id_centro
   			FROM tabla_acuerdos_movilidad_2020 AS acuerdosm20, centro AS c
   			WHERE acuerdosm20.in_out = 'OUT' and c.nombre_centro = acuerdosm20.centro
   			UNION ALL
   			SELECT acuerdosm21.nombre_idioma_nivel_movilidad AS nombre_idioma_nivel_movilidad, 
   				acuerdosm21.universidad_acuerdo AS universidad_acuerdo,
   				acuerdosm21.pais_universidad_acuerdo AS pais_universidad_acuerdo, 
   				cast(acuerdosm21.plazas_asignadas_alumnos_out as int) AS plazas_asignadas_alumnos_out, 
   				acuerdosm21.in_out AS in_out, 
   				acuerdosm21.nombre_programa_movilidad AS nombre_programa_movilidad,
   				c.id_centro AS id_centro
   			FROM tabla_acuerdos_movilidad_2021 AS acuerdosm21, centro AS c
   			WHERE acuerdosm21.in_out = 'OUT' and c.nombre_centro = acuerdosm21.centro
   ) AS sub_convenio_movilidad;"
   
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "INSERT INTO resultado (duracion_media_graduados, alumnos_graduados,
   alumnos_con_reconocimiento, alumnos_nuevo_ingreso, creditos_matriculados, creditos_reconocidos,
   alumnos_matriculados, tasa_rendimiento, tasa_exito, id_estudio)
   SELECT DISTINCT duracion_media_graduados, alumnos_graduados,
   		alumnos_con_reconocimiento, alumnos_nuevo_ingreso, creditos_matriculados, creditos_reconocidos,
   		alumnos_matriculados, tasa_rendimiento, tasa_exito, id_estudio
   FROM (
   			SELECT DISTINCT cast(resultados19.duracion_media_graduados as double precision) AS duracion_media_graduados, 
   				cast(resultados19.alumnos_graduados as int) AS alumnos_graduados,
   				cast(resultados19.alumnos_con_reconocimiento as int) AS alumnos_con_reconocimiento, 
   				cast(resultados19.alumnos_nuevo_ingreso as int) AS alumnos_nuevo_ingreso, 
   				cast(resultados19.creditos_matriculados as double precision) AS creditos_matriculados, 
   				cast(resultados19.creditos_reconocidos as double precision) AS creditos_reconocidos,
   				cast(resultados19.alumnos_matriculados as int) AS alumnos_matriculados, 
   				cast(resultados19.tasa_rendimiento as double precision) AS tasa_rendimiento, 
   				cast(resultados19.tasa_exito as double precision) AS tasa_exito, 
   				e.id_estudio AS id_estudio
   			FROM tabla_resultados_titulaciones_2019 AS resultados19, estudios AS e, centro AS c
   			WHERE (SUBSTR(e.nombre_estudio, 8) = SUBSTR(resultados19.estudio, 3)) and c.id_centro = e.id_centro
   				and c.nombre_centro = resultados19.centro
   			UNION ALL
   			SELECT DISTINCT cast(resultados20.duracion_media_graduados as double precision) AS duracion_media_graduados, 
   				cast(resultados20.alumnos_graduados as int) AS alumnos_graduados,
   				cast(resultados20.alumnos_con_reconocimiento as int) AS alumnos_con_reconocimiento, 
   				cast(resultados20.alumnos_nuevo_ingreso as int) AS alumnos_nuevo_ingreso, 
   				cast(resultados20.creditos_matriculados as double precision) AS creditos_matriculados, 
   				cast(resultados20.creditos_reconocidos as double precision) AS creditos_reconocidos,
   				cast(resultados20.alumnos_matriculados as int) AS alumnos_matriculados, 
   				cast(resultados20.tasa_rendimiento as double precision) AS tasa_rendimiento, 
   				cast(resultados20.tasa_exito as double precision) AS tasa_exito, 
   				e.id_estudio AS id_estudio
   			FROM tabla_resultados_titulaciones_2020 AS resultados20, estudios AS e, centro AS c
   			WHERE (SUBSTR(e.nombre_estudio, 8) = SUBSTR(resultados20.estudio, 3)) and c.id_centro = e.id_centro
   				and c.nombre_centro = resultados20.centro
   			UNION ALL
   			SELECT DISTINCT cast(resultados21.duracion_media_graduados as double precision) AS duracion_media_graduados, 
   				cast(resultados21.alumnos_graduados as int) AS alumnos_graduados,
   				cast(resultados21.alumnos_con_reconocimiento as int) AS alumnos_con_reconocimiento, 
   				cast(resultados21.alumnos_nuevo_ingreso as int) AS alumnos_nuevo_ingreso, 
   				cast(resultados21.creditos_matriculados as double precision) AS creditos_matriculados, 
   				cast(resultados21.creditos_reconocidos as double precision) AS creditos_reconocidos,
   				cast(resultados21.alumnos_matriculados as int) AS alumnos_matriculados, 
   				cast(resultados21.tasa_rendimiento as double precision) AS tasa_rendimiento, 
   				cast(resultados21.tasa_exito as double precision) AS tasa_exito, 
   				e.id_estudio AS id_estudio
   			FROM tabla_resultados_titulaciones_2021 AS resultados21, estudios AS e, centro AS c
   			WHERE (SUBSTR(e.nombre_estudio, 8) = SUBSTR(resultados21.estudio, 3)) and c.id_centro = e.id_centro
   				and c.nombre_centro = resultados21.centro   			   				
   ) AS sub_resultados;"
   
#En las tablas asignatura y asignatura_anyo no se ha cargado el año 2021, porque en el fichero csv hay un error con una fila.
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "INSERT INTO asignatura (nombre_asignatura,
   	tipo_asignatura, clase_asignatura, id_estudio)
   	SELECT DISTINCT nombre_asignatura, tipo_asignatura, clase_asignatura, id_estudio
   	FROM (
   			SELECT DISTINCT rend19.asignatura AS nombre_asignatura,
   				rend19.tipo_asignatura AS tipo_asignatura, 
   				rend19.clase_asignatura AS clase_asignatura,
   				cast(e.id_estudio as int) AS id_estudio
   			FROM tabla_rendimiento_asignatura_titulacion_2019 AS rend19, estudios AS e
   			WHERE e.nombre_estudio = rend19.estudio 
   			UNION ALL
   			SELECT DISTINCT rend20.asignatura AS nombre_asignatura,
   				rend20.tipo_asignatura AS tipo_asignatura, 
   				rend20.clase_asignatura AS clase_asignatura,
   				cast(e.id_estudio as int) AS id_estudio
   			FROM tabla_rendimiento_asignatura_titulacion_2020 AS rend20, estudios AS e
   			WHERE e.nombre_estudio = rend20.estudio 	
   	) AS sub_asignatura;"

   	
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "INSERT INTO asignatura_anyo (alumnos_evaluados, alumnos_superados,
   alumnos_presentados, media_convocatorias_consumidas, id_asignatura)
   SELECT DISTINCT alumnos_evaluados, alumnos_superados, alumnos_presentados, media_convocatorias_consumidas, id_asignatura
   FROM ( 
   			SELECT DISTINCT cast(rend19.alumnos_evaluados as int) AS alumnos_evaluados, 
   				cast(rend19.alumnos_superados as int) AS alumnos_superados, 
   				cast(rend19.alumnos_presentados as int) AS alumnos_presentados,
   				cast(rend19.media_convocatorias_consumidas as double precision) AS media_convocatorias_consumidas,
   				cast(a.id_asignatura as int) AS id_asignatura  		
   			FROM tabla_rendimiento_asignatura_titulacion_2019 AS rend19, asignatura AS a, estudios AS e
   			WHERE a.nombre_asignatura = rend19.asignatura and a.id_estudio = e.id_estudio
   			UNION ALL
   			SELECT DISTINCT cast(rend20.alumnos_evaluados as int) AS alumnos_evaluados, 
   				cast(rend20.alumnos_superados as int) AS alumnos_superados, 
   				cast(rend20.alumnos_presentados as int) AS alumnos_presentados,
   				cast(rend20.media_convocatorias_consumidas as double precision) AS media_convocatorias_consumidas,
   				cast(a.id_asignatura as int) AS id_asignatura  		
   			FROM tabla_rendimiento_asignatura_titulacion_2020 AS rend20, asignatura AS a, estudios AS e
   			WHERE a.nombre_asignatura = rend20.asignatura and a.id_estudio = e.id_estudio
   ) AS sub_asignatura_anyo;"

## -- Eliminar las tablas temporales que se han creado anteriormente.
# Oferta y ocupación de plazas
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_oferta_ocupacion_2019;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_oferta_ocupacion_2020;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_oferta_ocupacion_2021;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_oferta_ocupacion;"

# Resultados de las titulaciones
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_resultados_titulaciones_2019;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_resultados_titulaciones_2020;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_resultados_titulaciones_2021;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_resultados_titulaciones;"

# Notas de corte definitivas del cupo general a estudios de grados
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_notas_corte_2019;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_notas_corte_2020;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_notas_corte_2021;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_notas_corte;"

# Acuerdos de movilidad de estudiantes ERASMUS y SICUE
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_acuerdos_movilidad_2019;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_acuerdos_movilidad_2020;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_acuerdos_movilidad_2021;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_acuerdos_movilidad;"

# Alumnos egresados por titulación
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_alumnos_egresados_titulacion_2019;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_alumnos_egresados_titulacion_2020;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_alumnos_egresados_titulacion_2021;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_alumnos_egresados_titulacion;"

# Rendimiento por asignatura y titulación
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_rendimiento_asignatura_titulacion_2019;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_rendimiento_asignatura_titulacion_2020;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_rendimiento_asignatura_titulacion_2021;"
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "DROP TABLE tabla_rendimiento_asignatura_titulacion;"


## --Implementa en nuestra BD un TRIGGER que registre en una tabla auxiliar todos las operaciones de borrado y
##actualización de datos en una cualquiera de las tablas de nuestro esquema, guardando operación, usuario, fecha
#y clave primaria afectada.
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE TABLE registro_operaciones (
    id SERIAL PRIMARY KEY,
    operacion varchar NOT NULL,
    usuario varchar NOT NULL,
    fecha TIMESTAMP NOT NULL,
    clave_primaria_afectada INTEGER NOT NULL
);"

psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE OR REPLACE FUNCTION registrar_operaciones_borrado_actualizacion() RETURNS trigger 
   AS '
   BEGIN
      IF (TG_OP = ''DELETE'') THEN
         INSERT INTO registro_operaciones (operacion, usuario, fecha, clave_primaria_afectada)
         VALUES (''DELETE'', current_user, current_timestamp, OLD.id_convenio_movilidad);
         return old;
      ELSIF (TG_OP = ''UPDATE'') THEN
         INSERT INTO registro_operaciones (operacion, usuario, fecha, clave_primaria_afectada)
         VALUES (''UPDATE'', current_user, current_timestamp, NEW.id_convenio_movilidad);
         return new;
      END IF;
   END;
   '
   LANGUAGE plpgsql;

   CREATE TRIGGER registro_operaciones
   AFTER DELETE OR UPDATE ON convenio_movilidad
   FOR EACH ROW
   EXECUTE FUNCTION registrar_operaciones_borrado_actualizacion();
   
   
   
   DELETE FROM convenio_movilidad WHERE id_convenio_movilidad = 1;
   UPDATE convenio_movilidad SET in_out = 'outt' WHERE id_convenio_movilidad = 2;
   SELECT * FROM registro_operaciones;"

## -- Lanza consulta SQL que devuelva los dos estudios de cada localidad con mayor índice de ocupación en el 2021.
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "SELECT nombre_estudio, localidad
   FROM (
      SELECT e.nombre_estudio, c.localidad, ea.indice_ocupacion, ROW_NUMBER() OVER (PARTITION BY c.localidad ORDER BY ea.indice_ocupacion DESC) AS
      		 mayor_ocupacion
      FROM estudios e, centro c, estudio_anyo ea
      WHERE e.id_estudio = ea.id_estudio and e.id_centro = c.id_centro 
            and ea.curso_academico = 2021
   ) mayor_indice
   WHERE mayor_indice.mayor_ocupacion <= 2;"

## -- Lanza consulta SQL que devuelva la universidad que más alumnos recibe de cada centro en el 2021.
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "SELECT DISTINCT cm.universidad_acuerdo, c.nombre_centro, c.localidad, SUM(cm.plazas_asignadas_alumnos_out)
   FROM estudios e, centro c, convenio_movilidad cm, estudio_anyo ea
   WHERE c.id_centro = e.id_centro and c.id_centro = cm.id_centro and e.id_estudio = ea.id_estudio
         and ea.curso_academico = 2021 and cm.in_out LIKE 'OUT'  
   GROUP BY cm.universidad_acuerdo, c.nombre_centro, cm.plazas_asignadas_alumnos_out, c.localidad, c.id_centro, ea.curso_academico
   HAVING SUM(cm.plazas_asignadas_alumnos_out) = (SELECT DISTINCT MAX(mayor_alumnos.total_plazas_asignadas_alumnos_out) 
         										  FROM (
         												SELECT DISTINCT SUM(cmm.plazas_asignadas_alumnos_out) as total_plazas_asignadas_alumnos_out
         												FROM convenio_movilidad cmm
         												WHERE c.id_centro = cmm.id_centro 
         													  and ea.curso_academico = 2021 and cmm.in_out LIKE 'OUT'
         												GROUP BY cmm.universidad_acuerdo
         										   ) as mayor_alumnos
         	 								  )
   "
 #Si un centro tiene varias universidades con mayor número de pazas_asignadas_alumnos_out mostrará todas esas universidades.
 
  
## -- Crear una vista que incluya las 10 asignaturas con mayor y menor tasa de éxito en el Grado en Ingeniería
## informática tanto de EINA como de EUPT.
#EINA = Escuela de Ingeniería y Arquitectura
#EUPT = Escuela Universitaria Politécnica de Teruel
psql -U $NOMBRE_USUARIO -d $NOMBRE_BD -c "CREATE VIEW vista_tasas_exitos AS
	SELECT sub_vista_tasa_exitos.nombre_asignatura, sub_vista_tasa_exitos.nombre_centro, 
		sub_vista_tasa_exitos.nombre_estudio, sub_vista_tasa_exitos.tasa_exito_mayor, sub_vista_tasa_exitos.tasa_exito_menor
	FROM(
		SELECT a.nombre_asignatura, r.tasa_exito, c.nombre_centro, e.nombre_estudio, 
			ROW_NUMBER() OVER(PARTITION BY c.nombre_centro ORDER BY r.tasa_exito DESC) AS tasa_exito_mayor,
           	ROW_NUMBER() OVER(PARTITION BY c.nombre_centro ORDER BY r.tasa_exito ASC) AS tasa_exito_menor
		FROM centro c, asignatura a, resultado r, estudios e
		WHERE c.id_centro = e.id_centro and e.id_estudio = r.id_estudio and e.id_estudio = a.id_estudio
      		and e.nombre_estudio LIKE 'Grado: Ingeniería Informática' 
      		and (c.nombre_centro LIKE 'Escuela de Ingeniería y Arquitectura'
      		or  c.nombre_centro LIKE 'Escuela Universitaria Politécnica de Teruel')
	)AS sub_vista_tasa_exitos
	WHERE sub_vista_tasa_exitos.tasa_exito_mayor <= 10 OR sub_vista_tasa_exitos.tasa_exito_menor <= 10
	GROUP BY sub_vista_tasa_exitos.nombre_centro, sub_vista_tasa_exitos.nombre_asignatura, sub_vista_tasa_exitos.tasa_exito,
			sub_vista_tasa_exitos.nombre_estudio, sub_vista_tasa_exitos.tasa_exito_mayor, sub_vista_tasa_exitos.tasa_exito_menor
	ORDER BY sub_vista_tasa_exitos.nombre_centro, sub_vista_tasa_exitos.tasa_exito DESC;
	
	
	
	SELECT * 
	FROM vista_tasas_exitos;"

## -- Crear usuario “profesor” con permisos de lectura y facilitar la contraseña en la documentación, comprobando
## su correcto funcionamiento previamente.

# Verifica si el usuario y la BD ya existen, si existen elimina los anteriores
sudo -u postgres psql -c "REVOKE ALL PRIVILEGES ON SCHEMA public FROM $NOMBRE_PROFESOR;"
sudo -u postgres psql -c "DROP USER IF EXISTS $NOMBRE_PROFESOR;"

# Crear usuario "profesor" con permisos de lectura
sudo -u postgres psql -c "CREATE USER $NOMBRE_PROFESOR WITH PASSWORD '$PASSWORD';"
sudo -u postgres psql -c "GRANT USAGE ON SCHEMA public TO $NOMBRE_PROFESOR;"
sudo -u postgres psql -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO $NOMBRE_PROFESOR;"

echo "Se ha creado el usuario $NOMBRE_PROFESOR con permisos de lectura."
