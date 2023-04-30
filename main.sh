#!/bin/bash
#Cassandra Leder
#semester project
#19/4/23
#KEY: $1: remote-server, $2: remote-userid, $3: remote-file, $4: mysql-user-id, $5 mysql-database

GARBAGE=$(mktemp -t tmp.XXXXXXXXXX)
string="" #this string will be used in tandem with printCommandException function

# if file does not exist
if test -f "$1"; then
    : # no op
else
    >&2 printf "\nMust be a file\n"
    exit 1
fi

#Make sure there are enough args
if [[ $# != 5 ]]; then
       >&2  printf "\nCorrect usage is: ./main.sh remote-server remote-userid, remote-file, mysql-user-id, mysql-database\n"
        exit 1
fi

#This function lets the end user know whether the last command executed correctly. $1 is the message to be displayed
printCommandException () {
    eval testing=$1
	if $testing; then
		printf "${string} was successful\n"
	else 
		>&2 printf "\n%s failed\n", $1; exit 1
	fi
}

#erases the created temp file
garbageCollector () {
	printf "\n Please hold while temporary files are being removed\n"
	rm -rf $GARBAGE
	
	if [[ printCommandException == true ]]; then
		printf "\n%s\n", "Trash has been taken out!"
	fi
}

#transfer source file with scp command to project directory (on local machine /usr/cassie/semester-project/
#the command with default variables: scp cleder@class-svr:/home/shared/MOCK_MIX_v2.1.csv.bz2 ./
printf "\nRetrieving file now...\n"

./retrievefile.sh $1 $2 $3

#find the filename
echo $3 > $GARBAGE

filename=$(awk -f findname.awk $GARBAGE)

#unzip transaction file
bunzip2 -f $filename

#now we need to remove the .bz2 from the file name
echo $filename > $GARBAGE
filename=$(sed 's/.bz2//' $GARBAGE) 

#remove header record from the transaction file
tail -n +2 $filename > $GARBAGE

cat $GARBAGE > $filename

#convert all the text in transaction file to lower case
tr 'A-Z' 'a-z' < $filename > $GARBAGE

cat $GARBAGE  > $filename

#convert gender fields to all "f", "m", and "u"
sed -i 's/[Mm]ale/m/g' $filename
sed -i 's/[Ff]emale/f/g' $filename #problem w this line..
sed -i 's/0\/m/g'
sed -i 's/1\/f/g'

#filter out all the records from the transcation file from "state" field that do not have a state or contain "NA". Remove them from original and quarentine them in exceptions.csv
./filterstates.sh $filename

#Remove the $ sign in the transaction file from the "purchase_amt" field
./removedollarsign.sh $filename

#sort transaction file by customerID. format shouldn't change. final transaction file should be called transaction.csv
sort -k 1,1 $filename

#generate a summary file using transaction.csv. look at .pdf for pertitent details

#take out trash
trap garbageCollector 1 2 3 6

exit 0
