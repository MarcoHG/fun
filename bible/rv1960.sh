#!/bin/bash

# BBCCC-Book_CC.mp3 	BB is 1 to 66, 
#	BBCCC-Book_CCC.mp3 for Salmos 
# Book for Mateo, Marcos, Lucas, Juan has a 'San_' prefix
# Input at most 3 arguments: [n] bookName [chapter]
# n is 1,2 or 3

# Global books array variable
books=('non-zero' 
'Genesis' 'Exodo' 'Levitico' 'Numeros' 'Deuteronomio' 
'Josue' 'Jueces' 'Rut' '1_Samuel' '2_Samuel'
'1_Reyes' '2_Reyes' '1_Cronicas' '2_Cronicas' 
'Esdras' 'Nehemias' 'Ester' 'Job' 
'Salmos' 'Proverbios' 'Eclesiastes' 'Cantares' 
'Isaias' 'Jeremias' 'Lamentaciones' 'Ezequiel' 'Daniel'
'Oseas' 'Joel' 'Amos' 'Abdias' 'Jonas' 'Miqueas' 'Nahum' 'Habacuc' 'Sofonias' 'Hageo' 'Zacarias' 'Malaquias'
'San_Mateo' 'San_Marcos' 'San_Lucas' 'San_Juan'
'Hechos' 'Romanos' '1_Corintios' '2_Corintios'
'Galatas' 'Efesios' 'Filipenses' 'Colosenses' '1_Tesalonicenses' '2_Tesalonicenses'
'1_Timoteo' '2_Timoteo' 'Tito' 'Filemon' 'Hebreos' 'Santiago' 
'1_Pedro' '2_Pedro' '1_Juan' '2_Juan' '3_Juan' 'Judas' 'Apocalipsis')
numBooks=66

# Get arguments in local global vars: prefix book chapter, 
_a=$1
_b=$2
_c=$3

hasPrefix() {
if [[ $_a == 1 || $_a == 2 || $_a == 3 ]]; then
	bookPrefix=1
else 	
	bookPrefix=0 
fi
}


getBookName() {
	local name
	local book
	local san=""
	
	if [[  $bookPrefix == 1  ]]; then
		book=${_b^}
		name="$(printf "%d_%s" $_a $book)"
	else
		book=${_a^};
		if [[ $book == "Mateo" || $book == "Lucas" || $book == "Marcos" || $book == "Juan" ]]; then
			san="San_"
		fi
		name="$(printf "%s%s" $san $book)"
	fi
	echo -n $name
}

getFullName() {
	local full
	if [[ $bookPrefix == 1 ]]; then
		full=$(printf "%02d%03d %s_%02d.mp3" $i $_c $Book $_c)			
	else
		# Handle special case - Psalms has three digits in sufix
		full=$(printf "%02d%03d-%s_%02d.mp3" $i $_c $Book $_c)			
	fi 
	echo -n $full
}

getChapter() {
	local ch
	if [[ $bookPrefix == 1 ]]; then
		ch=$_c
	else
		ch=$_b
	fi
	# If no chapter given. start with 01
	if [[ -z $ch ]]; then
			ch=1
	fi
		 
	echo -n $ch 
}


# Script starts
hasPrefix

# Normalize book name as it will appear in filename
Book="$(getBookName)"
Chapter="$(getChapter)"
echo search $Book $Chapter

for ((num=1 ; num <= $numBooks ; ++num )); do
	# get next book name from array 
	bb=${books[$num]}

	if [[ $Book == $bb ]]; then
		echo found $bb
		if [[ $Book == "Salmos" ]]; then
			fullname="$(printf "%02d%03d-%s_%03d.mp3" $num $Chapter $Book $Chapter )"	
		else
			fullname="$(printf "%02d%03d-%s_%02d.mp3" $num $Chapter $Book $Chapter )"	
		fi
	fi
done

if [[ -n $fullname ]]; then
	urlName="http://wc-controls.com/biblia/$fullname"
	ffplay  -x 250 -y 250 -loglevel quiet -window_title "$Book-$Chapter" $urlName &
	#echo $urlName
fi



