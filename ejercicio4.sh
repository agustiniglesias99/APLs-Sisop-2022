#!/bin/bash

# ./ejercicio4.sh -e extensiones.txt -c / -s -p num -o salida.txt

function ayuda() {
    echo ""
    echo "AYUDA"
    echo "El script compara los archivos de un directorio e informa cuales son similares"
    echo "y que porcentaje de similitud tienen, por pantalla o en el archivo indicado."
    echo "-Ejemplos de ejecución:"
    echo "./ejercicio4.sh -e extensiones.txt -c  -p <num> -o salida.txt"
    echo "./ejercicio4.sh -e extensiones.txt -s -p <num>"
    echo "./ejercicio4.sh -h"
    echo ""
}

comentario=false            #Tengo que setearlas en falso porque si no cuando verifico si enviaron ambos parametros no funciona
sincomentario=false

options=$(getopt -o hd:e:csp:o: --l help,,dir:,ext:,coment,sincom,porc:,salida: -- "$@" 2> /dev/null)
# VALID_ARGUMENTS=$?
#if [ "$VALID_ARGUMENTS" != "0" ]
if [ "$?" != "0" ]      #$? codigo de salida del ultimo comando
then
    echo 'Las opciones indicadas son incorrectas.'
    ayuda
    exit 1
fi

eval set -- "$options"
while true
do
    case "$1" in

        -d | --dir)
            directorio="$2"
            shift 2                         #every time we call shift it pushes one (or more) off the stack. 

            if [ ! -d "$directorio" ]       #-d directorio: verdadero si el directorio existe.
            then
                echo "$directorio no existe o no es un directorio."
                ayuda
                exit 1
            elif [ ! -r "$directorio" ]
            then
                echo "$directorio no tiene permisos de lectura."
                ayuda
                exit 1
            fi
            ;;

        -e | --ext)
            extensiones="$2"
            shift 2                         #every time we call shift it pushes one (or more) off the stack. 

            if [ ! -f "$extensiones" ]      #-f archivo: verdadero si el archivo existe y es un archivo normal.
            then
                echo "$extensiones no existe o no es un archivo."
                ayuda
                exit 1
            elif [ ! -r "$extensiones" ]
            then
                echo "$extensiones no tiene permisos de lectura."
                ayuda
                exit 1
            fi
            ;;

        -c | --coment)
            comentario=true
            shift 1
            ;;

        -s | --sincom)
            sincomentario=true
            shift 1
            ;; 


        -p | --porc)
            porcentaje="$2"
            shift 2

            if [ -z "$porcentaje" ]     #z se fija si el parametro está vacío
            then
                echo "$porcentaje tiene que tener un valor."
                ayuda
                exit 1
            fi
            ;;


        -o | --salida)
            salida="$2"
            shift 2

            if [ -z "$salida" ]     #z se fija si el parametro está vacío
            then
                echo "$salida tiene que tener un valor"
                ayuda
                exit 1
            fi

            #El archivo de salida se tiene q crear?? 
            #Habria que verificar si existe si no se tiene q crear
            #touch "$salida" 2> /dev/null        #La salida por error se pierde / redirige stderr a /dev/null
            #if [ $? -ne 0 ]                     #touch crea fichero vacio si no existe el path
            #then
            #    echo "$salida no se pudo crear"
            #    exit 1
            #fi
            ;;

        -h | --help)
            ayuda
            exit 0
            ;;
        --)            #-- means the end of the arguments; drop this, and break out of the while loop
            shift
            break
            ;;
        *)
            echo "Error"
            exit 1
            ;;
    esac
done

# Validación de parámetros coment y sincom, no se pueden recibir los dos al mismo tiempo
if [ $comentario == "true" ] && [ $sincomentario == "true" ]
then
    echo "No se pueden recibir los comandos de -coment y -sincom al mismo tiempo."
    ayuda
    exit 1
fi

# splitear el archivo extensiones y armar un vector que tenga c/u de las extensiones
IFS=';'
str=$(cat $extensiones)
read -a arrExt <<< "$str"

#dps con un find filtrar los archivos que tengan esas extensiones

#If you want every files that do not end with .js, you can do:
#$ find -not -name "*.js" -type f

#for type in ${fileTypes[@]};do find -name "${type}"; done
##for type in ${fileTypes[@]};do find ! -name "${type}"; done       NEGADO??
#find -name "*${type}"          MIRAR EL *


for fichero in $(ls directorio)
do
    #verificar si la extencion está en el archivo pasado por paramentro en -ext
    extenAux=$(cut -d "." -f2 << $fichero)
    echo extenAux

    #contar la cantidad de lineas del archivo
    #cantLinDif=$(diff --suppress-common-lines --speed-large-files -y File1 File2 | wc -l)
done