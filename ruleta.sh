#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"



function ctrl_c(){
  echo -e "\n\n${redColour}[!]Saliendo...${endColour}\n"
  tput cnorm;exit 1
  
}


#Ctrl + C
trap ctrl_c INT

function helpPanel(){
  echo -e "${yellowColour}[+]${endColour}${grayColour} Uso de ${blueColour}$0${endColour}${endColour}"
  echo -e "\t${purpleColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
  echo -e "\t${purpleColour}-t${endColour}${grayColour} Tecnica a utilitzar${endColour} ${purpleColour}(martingala/inverseLabrouchere)${endColour}"
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour} ${yellowColour}$money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿Cuanto dinero tienes pensado apostar? ->${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A que deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar
  
  echo -e "${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de${endColour}${yellowColour} $initial_bet€${endColour} a${yellowColour} $par_impar${endColour}"
  play_counter=0
  jugadas_malas="[ "
  mejor_jugada=0
  tput civis
  backup_bet=$initial_bet
  while true; do
    money=$(($money-$initial_bet))
#    echo -e "\n${yellowColour}[+]${endColour}${grayColour}Acabas de apostar ${endColour} ${greenColour}$initial_bet€${endColour}${grayColour} y tienes${endColour}${greenColour} $money€${endColour}"
    random_number="$(($RANDOM%37))"

#    echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero${endColour}${blueColour} $random_number${endColour}"
    if [ ! "$money" -lt 0 ]; then
      if [ $par_impar == "par" ];then
        if [ "$(($random_number%2))" -eq 0 ]; then

          if [ $random_number -eq 0 ]; then
   #         echo -e "${yellowColour}[-]${endColour}${redColour}Ha salido el 0${endColour}"
            initial_bet=$(($initial_bet*2))
            jugadas_malas="$random_number "
   #         echo -e "${yellowColour}[+]${endColour}${redColour} Tienes $money€${endColour}"
          else

    #        echo -e "${yellowColour}[+]${endColour}${greenColour} El numero que ha salido es par ¡ganas!${endColour}"
            reward=$(($initial_bet*2))
     #       echo -e "${yellowColour}[+]${endColour}${greenColour} Ganas un total de $reward€${endColour}"
            money=$(($money+$reward))
    #        echo -e "${yellowColour}[+]${endColour}${greenColour} Tienes $money€${endColour}"
            initial_bet=$backup_bet
            if [ $money -gt $mejor_jugada ]; then
              mejor_jugada=$money
            fi
            jugadas_malas=""
          fi
        else

     #     echo -e "${yellowColour}[-]${endColour}${redColour} El numero que ha salido es impar, ¡Pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
      #    echo -e "${yellowColour}[+]${endColour}${redColour} Tienes $money€${endColour}"

        fi
      else
        if [ "$(($random_number%2))" -eq 1 ]; then
#           echo -e "${yellowColour}[+]${endColour}${greenColour} El numero que ha salido es par ¡ganas!${endColour}"
            reward=$(($initial_bet*2))
#           echo -e "${yellowColour}[+]${endColour}${greenColour} Ganas un total de $reward€${endColour}"
            money=$(($money+$reward))
#            echo -e "${yellowColour}[+]${endColour}${greenColour} Tienes $money€${endColour}"
            initial_bet=$backup_bet
            if [ $money -gt $mejor_jugada ]; then
              mejor_jugada=$money
            jugadas_malas=""
          fi
        else

#          echo -e "${yellowColour}[-]${endColour}${redColour} El numero que ha salido es impar, ¡Pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour}${redColour} Tienes $money€${endColour}"

        fi
      fi
    else
      #Nos quedamos sin dinero
      echo -e "\n${redColour}[!!!] The has quedado sin dinero${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de ${endColour} ${yellowColour} $play_counter${endColour}${grayColour} jugadas${endColour}"
      
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuacion se van a mostrar las jugadas malas consecutivas y la mayor cantidad de dinero ganada:${endColour} \n"
      echo -e "${blueColour}[ $jugadas_malas]${endColour}"
      echo -e "\n${blueColour}$mejor_jugada€${endColour}"

      exit 0 
      tput cnorm 
    fi
    tput cnorm
    let play_counter+=1
  done
  tput cnorm

}



while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  else
    echo -e "\n${redColour}[!] La tecnica introducida no existe${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
