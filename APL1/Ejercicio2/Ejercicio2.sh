#!/bin/bash

####################   ENCABEZADO    ##########################
#							      							  #
#	Nombre del script: Ejercicio2.sh		     			  #
#	Número de APL : 1				     					  #
#	Número de Ejercicio: 2                                    #
#   Primer Entrega      				 				      #
#							    							  #
#  INTEGRANTES:						  					      #
#	Morandi Mayra          41454827 				          #
#	Iglesias Agustin Ariel 41894233							  #
#	Zarzycki Hernan        39244031         				  #
#	Monteros Matias Javier 40886497							  #
#	Casaux Nicolas         39347293 						  #
#							      							  #
##############################################################


function ayuda() {
    echo "El proposito de este script es verificar que ciertas cadenas no se encuentren en los archivos dentro un directorio específico"
    echo "Para ejecutar el script ingrese:";
    echo "./Ejercicio2.sh --diff miDirectorioDiff --check misCadenas.txt"
    echo "El parámetro --diff indica el directorio que contiene los archivos a analizar"
    echo "El parámetro --check indica el archivo de texto, que contiene las cadenas que van a tenerse en cuenta para analizar los archivos"
}

if [ $# -eq 0 ]; then
    echo "No se ingresaron parámetros. Para obtener informacion sobre uso del script: -h --help o -?"
    exit
elif [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "-?" ]; then
        ayuda
        exit
fi

for i in "$@"
do
 if [ "$i" == "--diff" ]; then
    directorio="$2";
 fi
 if [ "$i" == "--check" ]; then
    archCadenas="$2";
 fi
 shift
done

if [ ! -d "$directorio" ]; then
    echo "¡ERROR! $directorio no existe o no es un directorio. Para obtener informacion sobre uso del script: -h -help o -?"
    exit
elif [ ! -r "$directorio" ]; then
    echo "No tiene permisos de lectura para $directorio"
else
    IFS=$'\n'

    archivos_a_analizar=(`find "$directorio" -type f`)

    if [ ${#archivos_a_analizar[@]} -eq 0 ]; then
        exit 0
    fi

    #cargo todas las cadenas del archivo en el array
    declare -a arrayCadenas=(`awk -f crearArray.awk $archCadenas`)

    if [ ${#arrayCadenas[@]} -eq 0 ]; then
        exit 0
    fi

    for arch in ${archivos_a_analizar[@]}
    do
        if [ ! -r "$arch" ]; then
            echo "no tiene permisos de lectura para $arch"
        else
            for linea in ${arrayCadenas[@]}
            do
                if grep -q $linea $arch; then
                    exit 1  #encontro una cadena dentro de los archivos
                fi
            done
        fi
    done
    exit 0 #no encontro ninguna cadena dentro de los archivos
fi