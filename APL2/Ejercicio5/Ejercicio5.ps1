
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
    [string]
    $entrada,
    [Parameter(Mandatory=$false)]
    [string]
    $salida,
    [Parameter(Mandatory=$false)]
    [string]
    $backup
)

#region Declaracion de funciones

function obtener_producto_mas_vendido{
    param (
        [string]$sucursal
    )
    $listadoDias = New-Object System.Collections.ArrayList
    $listadoDias = @(Get-ChildItem -Path $sucursal -File | Where-Object {$_.Name -match '*.txt$'})
}


#endregion

if ((Test-Path -Path $entrada) -ne $true) {
    Write-Host "El direcotrio $entrada no existe"
    exit 1
}

if (($salida.ToString().Length -gt 0) -and (Test-Path -Path $salida) -ne $true){
    Write-Host "El directorio $salida no existe"
    exit 1
}

$listaSucursales = New-Object System.Collections.ArrayList

$listaSucursales = @(Get-ChildItem -Path $entrada -Recurse -Directory)

foreach($directorio in $listaSucursales){

}