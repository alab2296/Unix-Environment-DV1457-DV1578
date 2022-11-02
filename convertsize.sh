#/bin/sh

SHOULD_PRINT=1
BYTES=0
KB=0
MB=0
GB=0


#Unused regex matching all valid inputs
#if [[ "$1" =~ [0-9]+[KMG]?[B] ]] #if input matches following regex: 1 or more numbers followed by K, M or G 0 or 1 times followed by B

if [[ "$1" =~ [0-9]+B ]] #Bytes
then
  #echo "Byte"
  NUMBER=${1::-1} #Remove final character from 1 and store the new substring in NUMBER
  BYTES=$NUMBER
  KB=$(bc <<< "scale=4 ; $BYTES / 1024") #scale=4 means calculate with 4 decimals
  MB=$(bc <<< "scale=4 ; $KB / 1024")
  GB=$(bc <<< "scale=4 ; $MB / 1024")

elif [[ "$1" =~ [0-9]+KB ]] #Kilobytes
then
  #echo "Kilobyte"
  NUMBER=${1::-2}
  KB=$NUMBER
  BYTES=$(bc <<< "scale=4 ; $KB * 1024")
  MB=$(bc <<< "scale=4 ; $KB / 1024")
  GB=$(bc <<< "scale=4 ; $MB / 1024")

elif [[ "$1" =~ [0-9]+MB ]] #Megabytes
then
  #echo "Megabyte"
  NUMBER=${1::-2}
  MB=$NUMBER
  KB=$(bc <<< "scale=4 ; $MB * 1024")
  BYTES=$(bc <<< "scale=4 ; $KB * 1024")
  GB=$(bc <<< "scale=4 ; $MB / 1024")

elif [[ "$1" =~ [0-9]+GB ]] #Gigabytes
then
  #echo "Gigabyte"
  NUMBER=${1::-2}
  GB=$NUMBER
  MB=$(bc <<< "scale=4 ; $GB * 1024")
  KB=$(bc <<< "scale=4 ; $MB * 1024")
  BYTES=$(bc <<< "scale=4 ; $KB * 1024")

else #default
  echo "Invalid input. Type a number followed by either B, KB, MB or GB."
  SHOULD_PRINT=0
fi

if [ "$SHOULD_PRINT" == 1 ] #This will only print if user entered correct input
then
  echo ""   #Newline
  echo "    Bytes: $BYTES"
  echo "Kilobytes: $KB"
  echo "Megabytes: $MB"
  echo "Gigabytes: $GB"
fi
