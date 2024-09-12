#!/bin/bash

#Para dar color rojo al texto de la ejecución del programa
RED="\e[31m"
ENDCOLOR="\e[0m"

#Mostrado de mi marca de agua empleando los colores anteriormente definidos 
echo -e "${RED}AutoNmap By JBKira${ENDCOLOR}"

#Si el número de argumentos es 0 mostrar uso del programa, si no seguir con la ejecución
if [ $# -eq 0 ]; then 
  echo -e "El uso del comando debe efectuarse de la siguiente manera:\n ./AutoNmap.sh <ip-addr>";
else
  #Efectuamos un escaneo de puertos TCP sin que se muestre la ejecución en la terminal pero se guarde en un archivo
  nmap -p- -sS --min-rate 5000 -n -Pn --open $1 -oN scan &>/dev/null

  #Metemos en una variable los puertos en formato de lista para poder pasarselo al siguiente comando
  ports=$(cat scan | grep -e "^[1-9]" | awk {'print $1'} FS='/' | xargs | tr ' ' ',')

  #Mostramos los puertos TCP abiertos en la ejecución
  echo -e "Puertos TCP abiertos:\n$ports"

  #Eliminamos el archivo residual del primer comando
  rm scan

  #Realizamos el escaneo de servicios y scripts de reconocimiento sobre los puertos abiertos sin mostrar la ejecución
  nmap -p$ports -sCV -v -Pn -n $1 -oN services &>/dev/null

  #Tratamos el archivo del anterior comando para que solo muestre lo interesante del output
  cat services | grep -e "^[1-9,\|]"

  #Borramos el archivo residual del último escaneo
  rm services
fi
