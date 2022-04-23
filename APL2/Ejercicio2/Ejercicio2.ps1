
<#
#							      							  #
#	Nombre del script: Ejercicio2.sh		     			  #
#	Número de APL : 2   			     					  #
#	Número de Ejercicio: 2                                    #
#   Primer Entrega      				 				      #
#							    							  #
#  INTEGRANTES:						  					      #
#	Morandi Mayra               41454827 				      #
#	Iglesias Agustin Ariel      41894233					  #
#	Zarzycki Hernan             39244031         			  #
#	Monteros Matias Javier      40886497					  #
#	Casaux Nicolas              39347293 					  #
#							      							  #
#>

<#
.SYNOPSIS
     "El proposito de este script es verificar que ciertas cadenas no se encuentren en los archivos dentro un directorio específico"
     "Para ejecutar el script ingrese:";
.DESCRIPTION  
     "El parámetro -diff indica el directorio que contiene los archivos a analizar"
     "El parámetro -check indica el archivo de texto, que contiene las cadenas que van a tenerse en cuenta para analizar los archivos"
.EXAMPLE
    "./Ejercicio2.sh -diff miDirectorioDiff -check misCadenas.txt"
#>

Param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty]
    [string]
    $diff,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty]
    [string]
    $check
)

$existe = Test-Path -Path $Directorio

if ($existe -ne $true) {
    Write-Host "El direcotrio $Directorio no existe"
    exit 2
}

