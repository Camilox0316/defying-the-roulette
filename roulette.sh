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
  echo -e "\n\n${redColour}[!] Exiting...\n${endColour}"
  exit 1 && tput cnorm
}

# Ctrl+c
trap ctrl_c INT


function helpPanel (){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour} ${purpleColour}$0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour} ${grayColour}Amount of money to play${endColour}"
  echo -e "\t${blueColour}-t)${endColour} ${grayColour}Technique to play${endColour}"
  exit 1
}

allowedTechniques(){
  echo -e "\n${redColour}[!] Given technique does not exists${endColour}\n"
  echo -e "${yellowColour}[?]${endColour} ${grayColour}Allowed techniques are: ${endColour}\n"
  echo -e "\t${purpleColour}Martingala${endColour}"
  echo -e "\t${purpleColour}InverseLabrouchere${endColour}"
  echo -e ""
}

function martinGala(){
  echo -e "Playing martingala"
}

inverseLabrouchere(){
  echo -e "Playing inverseLabrouchere"
}
while getopts "m:t:h" arg ; do
  case $arg in 
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ] ; then

  technique_lower="$(echo "$technique" | awk '{print tolower($0)}')"

  if [ "$technique_lower" == "martingala" ]; then
    martinGala
  elif [ "$technique_lower" == "inverselabrouchere" ]; then
    inverseLabrouchere
  else
    allowedTechniques
  fi
else
  helpPanel
fi

