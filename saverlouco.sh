#!/bin/bash

#-------------------------------------------------------
# Data:        22 de Março de 2016
# Criado por:  Juliano Santos [SHAMAN]
# Script:      saverlouco.sh
# Descrição:   Screensaver muito doido
# Página:      http://www.shellscriptx.blogspot.com.br
# Github:      https://github.com/shellscriptx
#-------------------------------------------------------

[[ $* ]] || { echo "Uso: $0 texto"; exit 0; } 

trap 'tput reset' exit
tput civis

string="$*"
char=($(echo "$string" | sed 's/./& /g'))
iposx=(${!char[@]})
iposy=$(($(tput lines)/2))

c=1;x=0;y=0

optx=("((x++))" "((x--))")
opty=("((y++))" "((y--))")

while [ $x -le $(($(tput lines)-1)) ]; do
	clear
	tput cup $y $x; echo -n "$string"
	((x++)); ((y++))
	sleep 0.1
done

for val in ${iposx[@]}
do
	vx+=($((x+val)))
	vy+=($y)
done

len=1; f=0; t=0

while true; do
	clear
	xs=$(($(tput cols)-$len))
	ys=$(($(tput lines)-1))
	
	for i in $(seq 0 $((${#char[@]}-1)))
	do
		if [ $f -le 50 ]; then
			xd[$i]=${optx[$(($RANDOM*2/35560))]}
			yd[$i]=${opty[$(($RANDOM*2/35560))]}
			tput setf $c
			((c++))
	    	[[ $c -gt 7 ]] && c=1                 
		elif [ $f -eq 51 ]; then
			tput sgr0
			xd[$i]=${optx[0]}
			yd[$i]=${opty[0]}
		elif [ $f -gt 201 ]; then
			f=0; t=1
		fi
			
		x=${vx[$i]}; y=${vy[$i]}
	
		if [ $t -eq 0 ]; then	
			[[ $y -ge $ys ]] && { yd[$i]="((y--))"; ((c++)); }    
    		[[ $y -le 0 ]] && { yd[$i]="((y++))"; ((c++)); }      
	    	[[ $x -ge $xs ]] && { xd[$i]="((x--))"; ((c++)); }   
	    	[[ $x -le 0 ]] && { xd[$i]="((x++))"; ((c++)); }    
		else
			[[ $y -gt $iposy ]] && { yd[$i]="((y--))"; ((c++)); }    
			[[ $y -lt $iposy ]] && { yd[$i]="((y++))"; ((c++)); }    
    		[[ $y -eq $iposy ]] && { unset yd[$i]; ((c++)); }      
	    	[[ $x -gt ${iposx[$i]} ]] && { xd[$i]="((x--))"; ((c++)); }   
	    	[[ $x -lt ${iposx[$i]} ]] && { xd[$i]="((x++))"; ((c++)); }
			[[ $x -eq ${iposx[$i]} ]] && unset xd[$i]
			[[ ! ${xd[@]} ]] && { f=0;t=0; break; }
		fi
			
   		eval "${xd[$i]}"; eval "${yd[$i]}"                                  
		vx[$i]=$x; vy[$i]=$y		
		tput cup $y $x; echo -n "${char[$i]}"
	done
	sleep 0.1
	((f++))
done
