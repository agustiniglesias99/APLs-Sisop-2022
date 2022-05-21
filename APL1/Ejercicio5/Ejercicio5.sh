#!/bin/bash

declare -a listaSucursales

#obtengo una lista de todos los directorios dentro de la entrada pasada por parametro
listaSucursales=(`find $1 -mindepth 1 -type d`) 



declare -a listadoDias
for item in ${listaSucursales[*]}
do
    listadoDias=(`find "$item" -name '*.txt' -type f`)
    for dia in ${listadoDias[*]}
    do
        contenido=$(cat "$dia") #cargo en un array todo el contenido del archivo del dia
        #echo $contenido
        tam=${#contenido[@]}
        if [ $tam -gt 0 ];then
            
            for (( i=1; i<=$tam-1; i++ ))
            do
                IFS='|'
                read -ra Actual<<<${contenido[$i]}
                productoActual=${Actual[0]}
                echo $productoActual
            done
        fi
    done
done
declare -A productosHash