#!/bin/bash
#Cassandra Leder
#semester project
#19/4/23
#KEY: $1: remote-server, $2: remote-userid, $3: remote-file, $4: mysql-user-id, $5 mysql-database

GARBAGE=$(mktemp -t tmp.XXXXXXXXXX)
string="" #this string will be used in tandem with printCommandException function

#This function lets the end user know whether the last command executed correctly. $1 is the message to be displayed
printCommandException () {
	eval string="$1"

	if [[ $? == 0 ]]; then
		printf "${string}  was successful\n"
		return 0
	else
		>&2 printf "\n%s failed\n", $1; exit 1
	fi
}

garbageCollector () {
	printf "\n Please hold while temporary files are being removed\n"
	rm -rf $GARBAGE
	
	if [[ printCommandException == true ]]; then
		printf "\n%s\n", "Trash has been taken out!"
	fi
}

#Make sure there are enough args
if [[ $# != 5 ]]; then
       >&2  printf "\nCorrect usage is: ./main.sh remote-server remote-userid, remote-file, mysql-user-id, mysql-database\n"
        exit 1
fi


#transfer source file with scp command to project directory (on local machine /usr/cassie/semester-project/
#the command with default variables: scp cleder@class-svr:/home/shared/MOCK_MIX_v2.1.csv.bz2 ./
printf "\nRetrieving file now...\n"
./retrievefile.sh $1 $2 $3

string="File retrieval"
printCommandException "\${string}"

#find the filename
echo $3 > $GARBAGE
filename=$(awk -f findname.awk $GARBAGE)

string="File name retrieval"
printCommandException "\${string}"


string="unzipping"

#unzip transaction file
bunzip2 -f $filename

printCommandException "\${string}"

#now we need to remove the .bz2 from the file name
echo $filename > $GARBAGE
filename=$(sed 's/.bz2//' $GARBAGE)

#remove header record from the transaction file
tail -n +2 $filename > $GARBAGE

string="Remove header from transaction file"
printCommandException "\${string}"

cat $GARBAGE > $filename

#convert all the text in transaction file to lower case
tr 'A-Z' 'a-z' < $filename > $GARBAGE

string="Text conversion to lower case "
printCommandException "\${string}"

cat $GARBAGE  > $filename

#convert gender fields to all "f", "m", and "u"
sed -i 's/[Mm]ale/m/g' $filename
sed -i 's/\b[Ff]emale\b/f/g' $filename
awk 'BEGIN { FS="," } { if ($5 !~ /[mf]/) { text=$5; sed -i "s/text/u/g" FILENAME  }}' $filename

#filter out all the records from the transcation file from "state"field that do not have a state or contain "NA". Remove them from original and quarentine them in exceptions.csv

#Remove the $ sign in the transaction file from the "purchase_amt" field

#sort transaction file by customerID. format shouldn't change. final transaction file should be called transaction.csv

#generate a summary file using transaction.csv. look at .pdf for pertitent details

#take out trash
trap garbageCollector 1 2 3 6

exit 0
