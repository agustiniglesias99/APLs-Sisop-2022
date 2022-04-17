<#
.SYNOPSIS
     "El proposito de este script es verificar que ciertas cadenas no se encuentren en los archivos dentro un directorio específico"
     "Para ejecutar el script ingrese:";
.DESCRIPTION  
     "El parámetro --diff indica el directorio que contiene los archivos a analizar"
     "El parámetro --check indica el archivo de texto, que contiene las cadenas que van a tenerse en cuenta para analizar los archivos"
.EXAMPLE
    "./Ejercicio2.sh --diff miDirectorioDiff --check misCadenas.txt"
#>

Param (
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty]
    [string]
    $Directorio,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty]
    [string]
    $archCadenas
)

$existe = Test-Path -Path $Directorio

if ($existe -ne $true) {
    Write-Host "El direcotrio $Directorio no existe"
    exit 1
}