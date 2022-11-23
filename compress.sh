#!/bin/bash




fun_compress(){
if [[ $1 == "7z" ]];then
7z a $file_name.7z $file_name > NUL:
else
find . -type f -name $file_name | parallel $1 -k --best
fi
}




size_cal(){

f_n=$1

size=()
size[0]=$(wc --bytes < $f_n)



f_n=$1.7z

size[1]=$(wc --bytes < $f_n)






f_n=$1.lzo

size[2]=$(wc --bytes < $f_n)





f_n=$1.bz2

size[3]=$(wc --bytes < $f_n)



f_n=$1.gz

size[4]=$(wc --bytes < $f_n)



}




min_compression(){


min=${size[0]}


for i in "${size[@]}"
do
    if [[ "$i" -lt "$min" ]]; then
        min="$i"
    fi
done



for i in "${!size[@]}"; do
   if [[ "${size[$i]}" = "$min" ]]; then
       fn="${i}";
   fi
done



method_name=${methods[$fn]}

echo "Most compression obtained with $method_name. Compressed file is $file_name.$method_name"





}



remove_maximum(){


for i in "${methods[@]}"
do
    
    if [[ "$i" == "$method_name" ]]; then
  
     echo ""
       else
         if [[ "$i" == "original" ]];then
         file=$file_name
rm $file
    else
    file="$file_name.$i"
rm $file
    fi
      
       
      
    fi
done



}





if [[ $1 != "" && -f "$1" ]];then

file_name=$1
methods=(original 7z lzo bz2 gz)
fun_compress bzip2 & fun_compress gzip & fun_compress lzop & fun_compress 7z
wait


size_cal $1

min_compression

remove_maximum

else 
echo "BAD:INPUT"
fi

