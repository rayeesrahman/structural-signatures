#!/bin/bash

##this script downloads the databases and sets up the environmental variable to for the pipeline to run
printf "Checking environment\n"
if  hash Rscript 2> /dev/null
then
	printf ""
else
	printf "R/Rscript is required to run this pipeline.\nPlease install the latest version of R and make sure Rscript is accesible from the command line.\n" ;
  printf "If you are on Ubuntu or using Windows Subsystem for Linux you can use the command: sudo apt-get -y install r-base  \n"
	exit 1 ;
fi

printf "This script downloads databases and sets up the environmental variables for the structural signatures pipeline.\n" ;
printf "This script may take a while to finish, are you sure you want to continue? [y/N] \n" ;
read input ;
if [  -d ./install.directory ]
then
  printf "It seems like structural-signatures.sh is already installed!\n"
  printf "Aborting\n"
  exit 1 ;
fi
if [ -z $input ] ||  [ $input == "n" ] || [ $input == "N" ] || [ $input == "No" ] || [ $input == "no" ] || [ $input == "NO" ] ; then
  printf "Aborting\n" ;
  exit 1 ;
elif [ $input == "y" ] || [ $input == "Y" ] || [ $input == "yes" ] || [ $input == "YES" ] || [ $input == "Yes" ] ; then
  printf "\n\033[1mInstalling structural-signatures.sh\033[0m \n\n";
else
  printf "Incorrect input, aborting\n" ;
  exit 1 ;
fi

printf "Downloading databses \n" ;
wget -O ./database.tar.gz https://www.dropbox.com/s/mmlgw164wb142ir/database.tar.gz?dl=1 ;
printf "Extracting database. This may take some time...\n" ;
tar -xzf ./database.tar.gz --totals
rm ./database.tar.gz
printf "Creating install.directory \n"
printf "$PWD\n"  > ./install.directory
./structural-signatures.sh -h > README.txt
printf "Done! Please read the README or use the -h option for help running structural-signatures.sh \n"
