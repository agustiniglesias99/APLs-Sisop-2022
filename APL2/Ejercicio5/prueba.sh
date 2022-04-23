#!/bin/bash
path="APL2/Ejercicio5/Entrada/Sucursal1/Lunes.txt"

maximo=(`awk -f analizarArchivo.awk $path`)

echo $maximo