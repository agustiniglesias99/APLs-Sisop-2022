#!/bin/bash

####################   ENCABEZADO    ##########################
#							      							  #
#	Nombre del script: Ejercicio5.sh		     			  #
#	Número de APL : 1				     					  #
#	Número de Ejercicio: 5                                    #
#   Primer Reentrega     				 				      #
#							    							  #
#  INTEGRANTES:						  					      #
#	Morandi Mayra          41454827 				          #
#	Iglesias Agustin Ariel 41894233							  #
#	Zarzycki Hernan        39244031         				  #
#	Monteros Matias Javier 40886497							  #
#							      							  #
##############################################################

function ayuda() {
    echo "El proposito de este script es contabilizar las ventas semanales de las sucursales de una tienda de golosinas"
    echo "El parámetro -e (obligatorio) indica el directorio que contiene los archivos a analizar, dentro de cada sucursal"
    echo "El parámetro -s (opcional) indica donde se generará el archivo final con los datos de las ventas"
    echo "El parámetro -k (opcional) se utiliza si se requiere almacenar los archivos en un archivo comprimido .zip"
    echo "Ejemplo: 
        ./Ejercicio5.ps1 -e ../Entrada/ -s Salida/ -k"
}

if [ $# -eq 0 ]; then
    echo "No se ingresaron parámetros. Para obtener informacion sobre uso del script: -h --help o -?"
    exit
elif [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "-?" ] || [ $# -gt 5 ]; then
        ayuda
        exit
fi
backup=false
for i in "$@"
do
 if [ "$i" == "-e" ]; then
    entrada="$2";
 fi
 if [ "$i" == "-s" ]; then
    salida="$2";
 fi
 if [ "$i" == "-k" ]; then
    backup=true;
 fi
 shift
done

if [ ! -d "$entrada" ]; then
    echo "¡ERROR! $entrada no existe o no es un directorio. Para obtener informacion sobre uso del script: -h -help o -?"
    exit
elif [ ! -r "$entrada" ]; then
    echo "No tiene permisos de lectura para $entrada"
    exit
elif [ ! -z "$salida" ] && [ ! -d "$salida" ]; then
    echo "¡ERROR! $salida no existe o no es un directorio. Para obtener informacion sobre uso del script: -h -help o -?"
    exit
elif [ ! -z "$salida" ] && [ ! -w "$salida" ]; then
    echo "No tiene permisos de escritura para $salida"
    exit
fi

if [ -z "$salida" ]; then
    salida="."
fi

declare -a listaSucursales

#creo el nombre del archivo log
fecha=`date '+%d-%m-%Y-%H-%M-%S'`".log"
	>"$salida/$fecha"

#obtengo una lista de todos los directorios dentro de la entrada pasada por parametro
listaSucursales=(`find $entrada -mindepth 1 -type d`) 

#echo ${listaSucursales[@]}

declare -a listadoDias
declare -a array
for item in ${listaSucursales[@]}
do  #inicio for sucursales
    listadoDias=(`find "$item" -name '*.txt' -type f`)
    declare -gA productosHash
    acum=0;
    for dia in ${listadoDias[*]}
    do  #inicio for dias
        if [[ -s $dia ]];then   #chequeo si el archivo no esta vacío
            contenido=$(cat "$dia")     #cargo en un array todo el contenido del archivo del dia
            IFS=$'\n'
            array=($contenido)  #convierto el contenido del archivo en un array separando por cada salto de linea
            tam=${#array[@]}
            
            for(( i=1; i < $tam; i++ ))
            do
            actual=${array[$i]} #itero por linea del archivo
            IFS=$'|'
            aux=($actual)   #convierto la linea en un array separando por |

            if [[ -v productosHash[${aux[0]}] ]];then
                productosHash[${aux[0]}]=$((productosHash[${aux[0]}]+${aux[1]}));
            else
                productosHash[${aux[0]}]=${aux[1]};
            fi
            recaudadoProducto=${aux[2]}
            acum=$((acum+$recaudadoProducto))
            
            IFS=$'\n'
            done

        fi
    done    #fin for dias

    #itero el array asociativo buscando el producto mas vendido
    valorMax=0
    for i in ${!productosHash[@]}
    do
        if [ $valorMax -lt ${productosHash[$i]} ];then
            valorMax=${productosHash[$i]}
            keyMax=$i
        fi
    done
    unset productosHash
    if [ $valorMax -gt 0 -a $acum -gt 0 ];then
        echo "El producto mas vendido para la sucursal $item fue $keyMax con un total de $valorMax" >> $salida/$fecha
        echo "El total recaudado fue de $acum"  >> $salida/$fecha
        echo "" >> $salida/$fecha
    else
        echo "No se vendieron productos para la sucursal $item durante esta semana"  >> $salida/$fecha
        echo "" >> $salida/$fecha
    fi

done #fin for sucursales

if [ $backup ]; then
    zipFile=`date '+%d-%m-%Y-%H-%M-%S'`".zip"
    zip -r $zipFile $entrada > /dev/null
fi

for item in ${listaSucursales[@]}
do
    rm $item/*
done