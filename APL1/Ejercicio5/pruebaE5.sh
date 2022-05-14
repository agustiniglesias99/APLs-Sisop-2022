#!/bin/bash

echo -e '\e[1;32m' "Con los archivos de datos_prueba genero la prueba" '\e[1;31m'
cp  -r datos_prueba/archivosSucursales archivosSucursales
echo -e "\n\n"  

 

echo -e '\e[1;32m'"---------------------------------------------"



echo -e '\e[1;32m' "Presione una tecla para continuar, se limpiara la pantalla"
	read $limpiar
	clear

echo -e '\e[1;32m' "Pruebo generar archivo log donde se ejecuta el script "
echo -e '\e[1;32m' "./Ejercicio5.sh -e " '\e[1;31m' "\"archivosSucursales\"" '\e[1;32m'

	./Ejercicio5.sh -e "archivosSucursales"
echo -e '\e[1;32m' "Muestro que creo archivo log donde se ejecuta el script, con ls "

ls
	
echo -e " \n \n "


echo -e '\e[1;32m'"---------------------------------------------"
#rmdir -r archivosSucursales
cp -r datos_prueba/archivosSucursales archivosSucursales
echo -e '\e[1;32m' "Pruebo generar backup  "
echo -e '\e[1;32m' "./Ejercicio5.sh -e archivosSucursales" '\e[1;31m' "-k" '\e[1;32m'  
	./Ejercicio5.sh -e archivosSucursales -k
echo -e '\e[1;32m' "Muestro que creo archivo zip donde se ejecuta el script, con ls "

ls
echo -e '\e[1;32m'"---------------------------------------------"




echo -e '\e[1;32m'"---------------------------------------------"

echo -e '\e[1;32m' "Presione una tecla para continuar, se limpiara la pantalla"
	read $limpiar
	clear

echo -e '\e[1;32m' "Pruebo enviar archivo log a un directorio enviado por parametro  "
 
 #rmdir -r archivosSucursales
cp -r datos_prueba/archivosSucursales archivosSucursales
echo -e '\e[1;32m' "./Ejercicio5.sh -e archivosSucursales" '\e[1;31m' "-s salida" '\e[1;32m'  
	./Ejercicio5.sh -e archivosSucursales -s salida

echo -e '\e[1;32m'"---------------------------------------------"



echo -e '\e[0m'
