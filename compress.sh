#/bin/sh

if [ $# == 0 ] # "$#" contains the number of arguments provided to the program
then
  echo "No input file specified."
elif [ $# -gt 1 ]
then
  echo "Enter only 1 file."
else
  if [ ! -f "$1" ] #Checks if input file exists. Also knows if file-type is directory or file.
  then
    echo "Specified file does not exist."
  else
    FILE_NAME=$(basename "$1")

    #Compress in parallell with the use of "&" by running the task in the background.
    #Without the -k flag, the original file gets deleted. p7zip does not have a
    #supress output flag, so I redirect it to a temporary textfile to prevent
    #flooding the console with text.
    gzip -k "$FILE_NAME" &
    bzip2 -k "$FILE_NAME" &
    p7zip -k "$FILE_NAME" > silencer_file.$$ ; rm silencer_file.$$ &
    lzop -k "$FILE_NAME" &
    wait #All compression must finish before going on to next step

    #List all files in current directory (in -long format) and send to file
    ls -l > temp_file.$$

    #Keep entries which match the name of the file to be compressed
    grep "$FILE_NAME" temp_file.$$ > temp_file2.$$

    #Compare the entries sizewise
    sort -nk 5 temp_file2.$$ > temp_file3.$$

    #The smallest file name is the entry on the 9th column of the first row
    SMALLEST_FILE=$(awk 'NR==1{print $9}' temp_file3.$$)

    #Remove the temp files
    rm temp_file.$$
    rm temp_file2.$$
    rm temp_file3.$$ #Comment this line out to verify that the program worked correctly

    #Flags
    ORIGINAL_DEL=1
    GZIP_DEL=1
    BZIP2_DEL=1
    P7ZIP_DEL=1
    LZOP_DEL=1

    #Change flag for the smallest file so it does not get deleted
    if [ "$SMALLEST_FILE" == "$FILE_NAME" ]
    then
      ORIGINAL_DEL=0
      echo "Compression made file larger, keeping original file"
    elif [ "$SMALLEST_FILE" == "$FILE_NAME.gz" ]
    then
      GZIP_DEL=0
      echo "Highest compression achieved with gzip"
    elif [ "$SMALLEST_FILE" == "$FILE_NAME.bz2" ]
    then
      BZIP2_DEL=0
      echo "Highest compression achieved with bzip2"
    elif [ "$SMALLEST_FILE" == "$FILE_NAME.7z" ]
    then
      P7ZIP_DEL=0
      echo "Highest compression achieved with p7zip"
    elif [ "$SMALLEST_FILE" == "$FILE_NAME.lzo" ]
    then
      LZOP_DEL=0
      echo "Highest compression achieved with lzop"
    else
      echo "An unexpected error occured, smallest file was not found"
    fi

    if [ "$ORIGINAL_DEL" == 1 ]
    then
      rm "$FILE_NAME"
    fi
    if [ "$GZIP_DEL" == 1 ]
    then
      rm "$FILE_NAME".gz
    fi
    if [ "$BZIP2_DEL" == 1 ]
    then
      rm "$FILE_NAME".bz2
    fi
    if [ "$P7ZIP_DEL" == 1 ]
    then
      rm "$FILE_NAME".7z
    fi
    if [ "$LZOP_DEL" == 1 ]
    then
      rm "$FILE_NAME".lzo
    fi

  fi
fi
