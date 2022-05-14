# ======================Inicio De Encabezado=======================

# Nombre del script: Ejercicio5.sh
# Número de ejercicio: 5
# Trabajo Práctico: 1
# Entrega: 19/04/2022

# =================================================================

# ~~~~~~~~~~~~~~~~~~~~~~~~ Integrantes ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
#   Nombre    |   Apellido    |    DNI
#   Micaela   |   Alazraki    |  41872978
#   Matias    |   Garin       |  40137539
#   Paula     |   Wawreniuk   |  25772017
#   Ágata     |   Quirico     |  42494877
#
# ======================Fin De Encabezado==========================

#!/bin/bash

#  <>

########### FUNCIONES

### informacion del -help
informacion () {

echo -e "\n\n"
echo -e '\e[1;35m' "DESCRIPCION=" '\e[1;32m'
echo " El script procesa informacion de archivos con informacion de sucursales de una golosineria; dentro de un directorio especifico, permitiendo  conocer cual fue el producto mas vendido, y cual es el monto total semanal por sucursal "
echo -e "\n"
echo " El script recibe obligatoriamente el  parametro -e con el directorio raiz con informacion de cada sucursal."
echo -e "\n"
echo -e "El script recibe opcionalmente el parametro -s que es el directorio donde se generara archivo .log,\n con la informacion procesada de todas las sucursales."
echo -e "\n"
echo -e "El script recibe opcionalmente el parametro -k indica que se generara un backup .zip del archivo .log,\n con la informacion procesada de todas las sucursales."
echo -e "\n"
echo -e '\e[1;35m' "PARAMETROS=" '\e[1;32m'
echo "-e con el directorio raiz con informacion de cada sucursal- obligatorio-"
echo -e "\n\n"
echo "-s con el directorio donde se genera archivo log- opcional-"
echo -e "\n\n"
echo "-k indica que se genera un backup .zip del archivo .log- opcional-"
echo -e "\n\n"
echo -e '\e[1;35m' "VERSION=" '\e[4;32m'
echo "Primera entrega"
echo -e "\n\n"'\e[0m'
echo -e '\e[1;35m' "NOTA=" '\e[1;34m'
echo ""
echo -e '\e[0m'
 exit 0
}

### validaciones
es_directorio(){

res=1
	if [ -d $1 ]
	then 
		res=0
	fi
return $res
}



nombre_archivo(){

#para validar que nombre del archivo sea un dia y con un formato
declare -a dias=([0]=lunes.txt [1]=martes.txt [2]=miercoles.txt [3]=jueves.txt [4]=viernes.txt [5]=sabado.txt [6]=domingo.txt)

resultado=0

#obtengo solo el nombre del archivo
#guardo nombre de archivo
archivo=`basename $1`

#normalizo el nombre
nombre_normalizado=`echo $archivo |tr "[:upper:]" "[:lower:]"`

	

#recorro el vector con nombre de dias y si coincide con nombre de archivo return 1 encontro
for i in ${dias[*]}
do
	if [ "$i" == "$nombre_normalizado" ]
	then
		resultado=1

	fi

done
					
return $resultado
}

cargo_archivo(){
#guardo en un unico archivo temporal la info de todas las sucursales

#guardo nombre de sucursal
nom_suc=`dirname $1`
nom_suc=`basename "$nom_suc"`

awk -v suc="$nom_suc" '	BEGIN{FS="|"}
	((NR>1)){
		print suc" "$1" "$2" "$3

	}
	END{
		FS=" "

	}
' "$1" >> "/tmp/aux_sucursales.txt"


}

calcula_maxImporte_maxCantidad(){

#creo el nombre del archivo log
fecha=`date '+%d-%m-%Y-%H-%M-%S'`".log"
	>"./$fecha"

nombre_log=$fecha

#calculo los importes y las cantidades
awk '	BEGIN{
		cant=0
		nombre=""
		imp=0
		
	}
	

		((NR==1)){	
				nombre=tolower($1)				
				imp+=$4
				producto[tolower($2)]+=$3
			}
		((NR>1)){
				if(nombre != tolower($1))
				{
					printf("%s importe semanal= %f", nombre,imp)
					printf("\n")
					imp=0

					max=-1
					p=""
					for(i in producto)
					{
						if(max == -1)
							{max=producto[i]
							p=i}
						else{
							if(max<producto[i])
								{max=producto[i]
								p=i
								}
							}
					}
	
					printf("%s es el producto mas vendido con %d unidades ", p,max)
					printf("\n")
					printf("-------------------------------------------------------------")
					printf("\n")

					for(i in producto)
						producto[i]=0

					nombre=tolower($1)
					imp+=$4
					producto[tolower($2)]+=$3

				}else
					{
									
					imp+=$4
					producto[tolower($2)]+=$3
					}
			}
		
		
		
		
		 END{
				printf("%s importe semanal= %f", nombre,imp)
					printf("\n")

				max=-1
					p=""
					for(i in producto)
					{
						if(max == -1)
							{max=producto[i]
							p=i}
						else{
							if(max<producto[i])
								{max=producto[i]
								p=i
								}
							}
					}
	
					printf("%s es el producto mas vendido con %d unidades ", p,max)
					printf("\n")
					printf("-------------------------------------------------------------")
					printf("\n")

			}

	
' "$1" > "./$fecha"
}




########### FIN FUNCIONES


########### MAIN


##########################################
# 	                                 #
#	Script principal                 #
#                                        #
##########################################

opcion_ingresada=""
nombre_log=""        #guarda el nombre del archivo log
aux=0
	# valido cantidad de parametros recibidos
	
	if [ $# -gt 0 ] && [ $# -lt 6 ]
	then
	# manejo de opciones con un case
	# uso vector asociativo para poder entrar al case

# Esto es para que tolere directorios con espacios
IFS="
" #salto de linea porque no me toma el "\n", esto es para directorios con espacios

aux=1
		declare -A entrada=(["-h"]=1 ["-help"]=1 ["-info"]=1 ["-?"]=1 ["e"]=2 ["k"]=3 ["s"]=4 ["sk"]=5  )
		
		### selector de parametros + algunas validaciones
		case $# in
	    		1) opcion_ingresada=$1
				aux=0
				 ;;
			2) 
			   #valido que sea -e
			   if [ "$1" = "-e" ] 
		           then    
				opcion_ingresada="e"
			   else
				echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
				exit 0
			   fi	
			   #valido si es directorio
			   es_directorio $2
			   if [ $? -eq 1 ] 
		           then    
				echo -e '\e[1;31m' "Error NO EXISTE DIRECTORIO . . . . ."'\e[0m'
				exit 0
			   fi
			    
				;;

			3)
			   #valido que sea -e
			   if [ "$1" = "-e" ] 
		           then    
				opcion_ingresada="e"
			   else
				echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
				exit 0
			   fi	
			   #valido si es directorio
			   es_directorio $2
			   if [ $? -eq 1 ] 
		           then    
				echo -e '\e[1;31m' "Error NO EXISTE DIRECTORIO . . . . ."'\e[0m'
				exit 0
			   fi

			   #valido que sea -k
			   if [ "$3" = "-k" ] 
		           then    
				opcion_ingresada="k"
			   else
				
				echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
				exit 0
				   
			   fi	
				;;
			4)  
			   #valido que sea -e
			   if [ "$1" = "-e" ] 
		           then    
				opcion_ingresada="e"
			   else
				echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
				exit 0
			   fi	
			   #valido si es directorio
			   es_directorio $2
			   if [ $? -eq 1 ] 
		           then    
				echo -e '\e[1;31m' "Error NO EXISTE DIRECTORIO . . . . ."'\e[0m'
				exit 0
			   fi

			   #valido que sea -s 
			   if [ "$3" = "-s" ] 
		           then 
				#valido si es directorio
				   es_directorio $4
				   if [ $? -eq 1 ] 
				   then    
					echo -e '\e[1;31m' "Error NO EXISTE DIRECTORIO . . . . ."'\e[0m'
					exit 0
				   fi   
				opcion_ingresada="s"
			   else
				
				echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
				exit 0
				   
			   fi
				;;

			5)

			   #valido que sea -e
			   if [ "$1" = "-e" ] 
		           then    
				opcion_ingresada="e"
			   else
				echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
				exit 0
			   fi	
			   #valido si es directorio
			   es_directorio $2
			   if [ $? -eq 1 ] 
		           then    
				echo -e '\e[1;31m' "Error NO EXISTE DIRECTORIO . . . . ."'\e[0m'
				exit 0
			   fi

			   #valido que sea -s -k  
			   if [ "$3" = "-s" ] 
		           then 
				#valido si es directorio
				   es_directorio $4
				   if [ $? -eq 1 ] 
				   then    
					echo -e '\e[1;31m' "Error NO EXISTE DIRECTORIO . . . . ."'\e[0m'
					exit 0
				   fi
				#valido que sea  -k 
				   if [ "$5" = "-k" ] 
				   then    
					opcion_ingresada="sk"
				else
					echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
					exit 0
				   
			   	fi
			   else
				
				#valido que sea  -k   -s
				   if [ "$3" = "-k" ] 
				   then 
					#valido si es directorio
					   es_directorio $5
					   if [ $? -eq 1 ] 
					   then    
						echo -e '\e[1;31m' "Error NO EXISTE DIRECTORIO . . . . ."'\e[0m'
						exit 0
					   fi
					#valido que sea  -s 
					   if [ "$4" = "-s" ] 
					   then    
						opcion_ingresada="sk"
					else
						echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
						exit 0
					   
				   	fi
				   else
					echo -e '\e[1;31m' "Error NO ES PARAMETRO VALIDO, consulte -help  . . . . ."'\e[0m'
					exit 0
				   fi
			   fi
				
				;;

			*)
				echo -e  '\e[1;31m' "CANTIDAD DE PARAMETROS INCORRECTO CONSULTE -help" '\e[0m'
				aux=0
				exit 0
				;;	
 
		esac
		### fin selector

		if [ $aux -eq 1 ] 
	   	then
		archivo_valido=0
	
		#vector que contiene archivos validos
		declare -a vector_archivo_valido
		cant_arch=0

		#falta arreglar lo de laruta absoluta

		# guardo todos los archivos del directorio de sucursales pero unicamente de nivel
			for file in $(find "$2"  -mindepth 2  -maxdepth 2 -name '*.txt' -type f   )
			do
#archivos[$indice]=$file

				nombre_archivo "$file"
				if [ $? -eq 1 ] 
					then    
						cargo_archivo "$file"
					fi

				vector_archivo_valido[cant_arch]="$file"
				((cant_arch++))

			done 

		#calcula los montos y articulos mas vendido de cada sucursal
		calcula_maxImporte_maxCantidad /tmp/aux_sucursales.txt

		fi
		
		### selector de opciones ingresadas
		# normaliza el parametro, a todas minuscilas, eso hace el codigo entre []
		# y comillas
		case "${entrada[`echo $opcion_ingresada| tr "[:upper:]" "[:lower:]"`]}" in
	    		1) 	
				informacion
		
				
				exit 0
				;;  ####### Ayuda

			2)	
				;;  ####### Genera .log donde se ejecuta script

			3)	
								
				nombre_backup=`date '+%d-%m-%Y-%H-%M-%S'`".zip"				

				#recorro vector y voy agregando al zip
				for i in ${vector_archivo_valido[*]}
				do
					zip -r "./$nombre_backup" "$i" >/dev/null #asi no
										# muestra los mensajes de "add" 

				done
				;;  ####### Genera backup con zip en directorio donde se ejecuta script


			4)

				# muevo el archivo al directorio enviado				
				mv -f $linea "./$nombre_log" "$4"  	

				;;  ####### Envia log al directorio enviado

			5)
				nombre_backup=`date '+%d-%m-%Y-%H-%M-%S'`".zip"				

				#recorro vector y voy agregando al zip
				for i in ${vector_archivo_valido[*]}
				do
					zip -r "$nombre_backup" "$i" >/dev/null #  >/dev/null asi no
													# muestra los mensajes de "add" 
				done
				if [ "$5" = "-k" ] 
				   then
					# muevo el archivo al directorio enviado				
					mv -f $linea "./$nombre_log" "$4"  
				else
					# muevo el archivo al directorio enviado				
					mv -f $linea "./$nombre_log" "$5"  
				fi	

				;;  ####### Envia log al directorio enviado y genera zip
				
			*)
				echo -e  '\e[1;31m' "NO INGRESO PARAMETRO ADECUADO CONSULTE -help   " '\e[0m'
				;;
		esac

		### fin selector 


	else
		echo -e  '\e[1;31m' "NO INGRESO LA CANTIDAD DE PARAMETROS ADECUADOS CONSULTE -help" '\e[0m'
		
	fi

if [ $aux -eq 1 ] 
   	then
		#borro los archivo temporal
		rm /tmp/aux_sucursales.txt

					
	for file in ${vector_archivo_valido[*]}	
	do	
	   rm $file
	done		
	fi

#vuelvo IFS a su valor inicial
IFS=' '
exit 0
		




















