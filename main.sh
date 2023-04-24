#!/bin/bash
#Cassandra Leder
#semester project
#19/4/23
#KEY: $1: remote-server, $2: remote-userid, $3: remote-file, $4: mysql-user-id, $5 mysql-database

$GARBAGE=$(mktemp -t tmp.XXXXXXXXXX)

#in tandem with the ./checkvalidity script, this function outputs a message for debugging and user purposes. args are $1: test command $2: message
printCommandException () {
	if [[ $1  == false ]]; then
		printf "\n%s was successful\n", $2
	else
		>&2 printf "\n%s failed\n", $2
	fi
}

function garbageCollector () {
	printf "\n Please hold while temporary files are being removed\n"
	printCommandException ./checkvalidity "rm -rf $GARBAGE", "Garbage removal"
}

if [[ $# != 5 ]]; then
       >&2  printf "\nCorrect usage is: ./main.sh remote-server remote-userid, remote-file, mysql-user-id, mysql-database\n"
        exit 1
fi


#transfer source file with scp command to project directory (on local machine /usr/cassie/semester-project/
#the command with default variables: scp cleder@class-svr:/home/shared/MOCK_MIX_v2.1.csv.bz2 ./
printf "\nRetrieving file now...\n"
printCommandException ./checkvalidity "./retrievefile.sh" $1 $2 $3, "File retrieval " 

#find the filename
filename=$(awk -f findname.awk $3)

#unzip transaction file
bunzip2 $filename

#remove header record from the transaction file
tail -n +2 $filename > tmp.txt
cat tmp.txt > $filename
mv tmp.txt $GARBAGE/

#convert all the text in transaction file to lower case
tr 'A-Z' 'a-z' < $filename > tmp.txt
cat tmp.txt > $filename

#convert gender fields to all "f", "m", and "u"

#filter out all the records from the transcation file from "state"field that do not have a state or contain "NA". Remove them from original and quarentine them in exceptions.csv

#Remove the $ sign in the transaction file from the "purchase_amt" field

#sort transaction file by customerID. format shouldn't change. final transaction file should be called transaction.csv

#generate a summary file using transaction.csv. look at .pdf for pertitent details

exit 0
