#!/bin/bash
#Cassandra Leder
#semester project
#19/4/23
#KEY: $1: remote-server, $2: remote-userid, $3: remote-file, $4: mysql-user-id, $5 mysql-database

if [[ $# != 5 ]]; then
	printf "\nCorrect usage is: ./main.sh remote-server remote-userid, remote-file, mysql-user-id, mysql-database\n"
	exit 1
fi



#transfer source file with scp command to project directory (on local machine /usr/cassie/semester-project/
#the command with default variables: scp cleder@class-svr:/home/shared/MOCK_MIX_v2.1.csv.bz2 ./
printf "\nRetrieving file now...\n"
./retrievefile.sh $1 $2 $3

if [[ $? == 1 ]]; then
	printf "\nOh no! file was unable to be retrieved! Make sure your information is correct\n"
else
	printf "\nFile retrieved successfully\n"
fi

#find the filename
filename=$(awk -f findname.awk $3)

#unzip transaction file
bunzip2 ./$filename

#remove header record from the transaction file
tail -n +2 $filename > temp.txt
cat temp.txt > $filename

#convert all the text in transaction file to lower case
tr 'A-Z' 'a-z' < $filename > temp.txt
cat temp.txt > $filename

#convert gender fields to all "f", "m", and "u"

#filter out all the records from the transcation file from "state"field that do not have a state or contain "NA". Remove them from original and quarentine them in exceptions.csv

#Remove the $ sign in the transaction file from the "purchase_amt" field

#sort transaction file by customerID. format shouldn't change. final transaction file should be called transaction.csv

#generate a summary file using transaction.csv. look at .pdf for pertitent details

exit 0
