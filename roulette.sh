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
  tput cnorm && exit 1
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

  #echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Current money:${endColour} ${blueColour}$money\$${endColour}"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}How much money do you want to bet? -> ${endColour}" && read initial_bet
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}What do you want to bet continuosly (even/odd)? -> ${endColour}" && read odd_even
  #echo -e "\n${yellowColour}[+]${endColour} ${grayColour}We are going to play with${endColour}${blueColour} ${initial_bet}\$ ${endColour}${grayColour}to${endColour}${purpleColour} ${odd_even}${endColour}\n"
  tput civis
  backup_bet=$initial_bet
  turns_counter=1
  bad_turns="[ "
  max_prize=$initial_bet
  while [ ! $money -le 0 ]; do
    
    random_number="$(($RANDOM % 37))"
    money=$(($money-$initial_bet))
    #echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You bet${endColour}${blueColour} ${initial_bet}\$ ${endColour} ${grayColour}and you have${endColour} ${blueColour}${money}\$ ${endColour}"
    #echo -e "${yellowColour}[+]${endColour} ${grayColour}Random number: ${endColour}${yellowColour}$random_number${endColour}"

    if [[ "$random_number" -ne 0 ]] && { { [[ "$(($random_number % 2))" -eq 0 ]] && [[ "$odd_even" == "even" ]]; } || { [[ "$(($random_number % 2))" -eq 1 ]] && [[ "$odd_even" == "odd" ]]; }; }; then
      #echo -e "${yellowColour}[+]${endColour} ${greenColour}You win! :D${endColour}"
      reward=$(($initial_bet*2))    
      #echo -e "${yellowColour}[+]${endColour} ${grayColour}You won: ${endColour} ${blueColour}$reward\$ ${endColour}"
      money=$(($money+$reward)) 
      #echo -e "${yellowColour}[+]${endColour} ${grayColour}Now you have: ${endColour}${blueColour}$money\$ ${endColour}"
      initial_bet=$backup_bet
      bad_turns=""
      max_prize=$money
    else
      #echo -e "${yellowColour}[+]${endColour} ${redColour}You lose! :(${endColour}"
      initial_bet=$(($initial_bet*2))
      money=$(($money))
      #echo -e "${yellowColour}[+]${endColour} ${grayColour}Now you have: ${endColour}${blueColour}$money\$ ${endColour}"
      bad_turns+="$random_number "
      if [ $money -le 0 ]; then
        #echo -e "\n${redColour}[!] You ran out of money${endColour}\n"
        echo -e "\n${redColour}[!] You ran out of money${endColour}\n"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Total turns:${endColour} ${purpleColour}$turns_counter${endColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour} The max prize was: ${endColour}${greenColour}$max_prize${endColour}"
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Bad turns:${endColour} ${redColour}$bad_turns${endColour}\n"

        tput cnorm && exit 0
      fi
    fi

    let turns_counter+=1
    #sleep 0.4

  done
  tput cnorm
  exit 0

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

