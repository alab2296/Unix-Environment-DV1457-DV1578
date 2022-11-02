#/bin/sh

if [ $# == 0 ] # "$#" contains the number of arguments provided to the program
then
  echo "No input directory specified."
elif [ $# -gt 1 ]
then
  echo "Enter only 1 directory."
else
  #echo "Valid input supplied"
  if [ ! -d "$1" ] #Checks if input directory exists. Also knows if file-type is directory or file.
  then
    echo "Specified directory does not exist."
  else
    #echo "Directory found"

    #Check if current working directory matches the parent of the directory we are trying to compress.
    #This is achieved by first using readlink on $1, in order to get the absolute path
    #of our input which may be relative. We then call dirname on that resulting string
    #to get the parent directory of the absolute path. If this parent directory matches our
    #current working directory, we are good to go.
    if [ $(pwd) != "$(dirname -- $(readlink -f "$1"))" ]
    then
      echo "You are not in the same directory as the directory to be compressed."
    else
      #echo "You are in the correct directory"
      DIR_NAME=$(basename "$1")

      #Check for write permissions on the directory to be compressed.
      #basename returns the string following the final directory separator (/)
      #or, if there is no directory separator, just the string. It's easiest to
      #think that it returns the name of the file/directory of a given path.
      if [ ! -w "$DIR_NAME" ]
      then
        echo "Cannot write the compressed file to the current directory"
      else
        #echo "User has write permission"

        #Store the size of the targeted directory in DU_OUTPUT.
        #The -b flag means show size in bytes.
        #The -c flag means show a total size as the final line in the output.
        DU_OUTPUT=$(du -bc "$DIR_NAME")

        #Using $$ (= the ID of the process running this program) as a file
        #extension will guarantee that it is unique and won't overwrite other files.
        touch du_output.$$

        #Send contents of DU_OUTPUT to the temporary file
        echo "$DU_OUTPUT" > du_output.$$

        #The total size of the directory is the first word of the final line.
        DIR_SIZE=$(awk '{awkvar=$1} END{print awkvar}' du_output.$$)
        rm du_output.$$ #Delete the temp file

        if [ $DIR_SIZE -gt 536870912 ] #512MB = 536 870 912 bytes
        then
          read -p "Warning: the directory is larger than 512 MB. Proceed? [y/n]: " USER_INPUT
          if [ "$USER_INPUT" == "y" ]
          then
            #Compress
            tar -zcf "$DIR_NAME".tar.gz "$DIR_NAME"
            echo "Directory $DIR_NAME archived as $DIR_NAME.tar.gz"
          else
            #Do nothing
            echo "Aborting"
          fi
        else
          #Compress
          tar -zcf "$DIR_NAME".tar.gz "$DIR_NAME"
          echo "Directory $DIR_NAME archived as $DIR_NAME.tar.gz"
        fi
      fi
    fi
  fi
fi
