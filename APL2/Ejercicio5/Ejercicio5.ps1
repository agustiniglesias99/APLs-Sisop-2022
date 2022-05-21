
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
#   Nicolas Ignacio Miron       39056120                      #
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
    [switch]
    $backup
)

 #region 
function calcularTotalYProductoMasVendido{
    param (
        [string]$sucursal,
        [string]$path
    )
    $listadoDias = New-Object System.Collections.ArrayList
    $productosHash = New-Object System.Collections.Hashtable
    $listadoDias = @(Get-ChildItem -Path $sucursal -File) #obtengo todos los dias de una sucursal
    $keyMax;
    $valorMax=0;
    $valorActual=0;
    $totalRecaudado=0;
    $nombreSucursal=(Get-ChildItem $sucursal)[0].directory.name;
    
    foreach($dia in $listadoDias){
        
        $contenido=(Get-Content $dia)   #cargo en un array todo el contenido del archivo dia
        if($contenido.Length -gt 0){
            
            $registros=$contenido -split "\n"   #spliteo el array anterio linea por linea
            if($registros[1].Length -gt 0){
                for($i=1;$i -lt $registros.Length;$i++){    #inicio i en 1 para saltear el texto del formato

                    $productoActual = ($registros[$i] -split "\|")[0];
                    $valorActual = [int]($registros[$i] -split "\|")[1];
                    $totalRecaudado += [int]($registros[$i] -split "\|")[2];

                    if( $productosHash.ContainsKey($productoActual)){
                        $productosHash[$productoActual] += $valorActual;
                    }
                    else{
                        $productosHash.Add("$productoActual", $valorActual);
                    }
                }
            }
        }
    }
    if($productosHash.GetEnumerator().Length -gt 0){
        foreach($item in $productosHash.GetEnumerator()){
            if($valorMax -lt $item.value){
                $valorMax=$item.Value;
                $keyMax=$item.Key;
            }
        }
        $valorMax=$productosHash[$keyMax]
        Add-Content -Path $path -Value "El producto mas vendido para la sucursal $nombreSucursal fue $keyMax con un total de $valorMax unidades"
        Add-Content -Path $path -Value "El total recaudado para la sucursal $nombreSucursal fue $totalRecaudado

        "
    }
    else{
            Add-Content -Path $path -Value "NO SE VENDIERON PRODUCTOS PARA LA SUCURSAL $nombreSucursal esta semana
            
            "
        }
}   

# #endregion

if ((Test-Path -Path $entrada) -ne $true) {
    Write-Host "El direcotrio $entrada no existe"
    exit 1
}

if (($salida.ToString().Length -gt 0) -and (Test-Path -Path $salida) -ne $true){
    Write-Host "El directorio $salida no existe"
    exit 1
}

if($salida.ToString().Length -eq 0){
    $salida=".";
}

$listaSucursales = New-Object System.Collections.ArrayList

$listaSucursales = @(Get-ChildItem -Path $entrada -Recurse -Directory)

if($backup){
    $nombreBackup=Get-Date -format "dd-MM-yyyy-hh-mm-ss.\zip";
    Compress-Archive -Path $entrada -DestinationPath $nombreBackup

}

$nombreLog=Get-Date -format "dd-MM-yyyy-hh-mm-ss.lo\g";
New-Item -Path $salida -ItemType "file" -Name $nombreLog | Out-Null

foreach($directorio in $listaSucursales){
    calcularTotalYProductoMasVendido -sucursal $directorio -path (Join-Path $salida $nombreLog)
    Get-ChildItem $directorio | ForEach  { $_.Delete()}
}
