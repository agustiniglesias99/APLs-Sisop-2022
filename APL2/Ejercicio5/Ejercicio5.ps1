
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

function obtener_producto_mas_vendido_dia {
    param (
        [string]$archivoDia
    )
        $max=0;
        $contenido=(Get-Content $archivoDia)
        $registros=$contenido -split "\n"
        for($i=1;$i -lt $registros.Length;$i++){
            $current=($registros[$i] -split "\|")[1]
            if($current -gt $max){
                $max=$current;
            }
        }
    return $max
}

function obtener_producto_mas_vendido_sucursal{
    param (
        [string]$sucursal
    )
    $listadoDias = New-Object System.Collections.ArrayList
    $listadoDias = @(Get-ChildItem -Path $sucursal -File)# | Where-Object {$_.Name -match '*.txt$'})
    $max=0;
    foreach($dia in $listadoDias){
        $current=(obtener_producto_mas_vendido_dia $dia)
        if($current -gt $max){
            $max=$current;
        }
    }
    return $max
}

function obtener_producto_mas_vendido_sucursal2{
    param (
        [string]$sucursal
    )
    $listadoDias = New-Object System.Collections.ArrayList
    $productosHash = New-Object System.Collections.Hashtable
    $listadoDias = @(Get-ChildItem -Path $sucursal -File) #obtengo todos los dias de una sucursal
    $keyMax;
    $valorMax=0;
    $valorActual=0;
    
    foreach($dia in $listadoDias){
        
        $contenido=(Get-Content $dia)   #cargo en un array todo el contenido del archivo dia
        $registros=$contenido -split "\n"   #spliteo el array anterio linea por linea
        if($registros[1].Length -gt 0){
            for($i=1;$i -lt $registros.Length;$i++){    #inicio i en 1 para saltear el texto del formato

                $productoActual = ($registros[$i] -split "\|")[0];
                $valorActual = [int]($registros[$i] -split "\|")[1];

                if( $productosHash.ContainsKey($productoActual)){
                    $productosHash[$productoActual] += $valorActual;
                }
                else{
                    $productosHash.Add("$productoActual", $valorActual);
                }
            }
        }
    }

    foreach($item in $productosHash.GetEnumerator()){
        if($valorMax -lt $item.value){
            $valorMax=$item.Value;
            $keyMax=$item.Key;
        }
    }
    Write-Host "el producto mas vendido para la sucursal" (Get-ChildItem $sucursal)[0].directory.name "fue " $keyMax "con un total de " $productosHash[$keyMax] "unidades"
}

# #endregion

obtener_producto_mas_vendido_sucursal2 "C:\Users\agust\repos\APLs-Sisop-2022\APL2\Ejercicio5\Entrada\Sucursal1"

# if ((Test-Path -Path $entrada) -ne $true) {
#     Write-Host "El direcotrio $entrada no existe"
#     exit 1
# }

# if (($salida.ToString().Length -gt 0) -and (Test-Path -Path $salida) -ne $true){
#     Write-Host "El directorio $salida no existe"
#     exit 1
# }

# $listaSucursales = New-Object System.Collections.ArrayList

# $listaSucursales = @(Get-ChildItem -Path $entrada -Recurse -Directory)

# foreach($directorio in $listaSucursales){

# }