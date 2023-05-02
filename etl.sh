#!/bin/bash
#Cassandra Leder
#semester project
#19/4/23

#KEY: $1: remote-server, $2: remote-userid, $3: remote-file, $4: mysql-user-id, $5 mysql-database
GARBAGE=$(mktemp -t tmp.XXXXXXXXXX)

#format for the /important/ args
ipadd=$(echo $1 | sed 's/[0-9.]//g')
userid=$(echo $2 | sed 's/[[:alnum:]]//g')

#ip addresses should only contain numbers and .
if [[ $ipadd != "" ]]; then
    >&2 printf "\nInvalid ip address\n"
    exit 1
fi

#userid should just be alnum
if [[ $userid != "" ]]; then
    >&2 printf "\nInvalid user name\n"
    exit 1
fi

#if file path doesn't exist, linux will shout at user so that's on them.

#Make sure there are enough args
if [[ $# < 2 ]]; then
       >&2  printf "\nCorrect usage is: ./main.sh remote-server remote-userid, remote-file, mysql-user-id, mysql-database\n"
        exit 1
fi

#erases the created temp file
garbageCollector () {
	printf "\nPlease hold while temporary files are being removed...\n"
	rm -rf $GARBAGE

	printf "\n%s\n", "Trash has been taken out!"
}

#transfer source file with scp command to project directory (on local machine /usr/cassie/semester-project/
#the command with default variables: scp cleder@class-svr:/home/shared/MOCK_MIX_v2.1.csv.bz2 ./
printf "\nRetrieving file now...\n"

#if command worked do nothing, else exit
if ./retrievefile.sh $1 $2 $3; then
        printf "\nFile successfully retrived by SCP\n"
else
        exit 1
fi

#find the filename
echo $3 > $GARBAGE

filename=$(awk -f findname.awk $GARBAGE)

# I tried to write a function for this, but it didn't work as intended :-(
if [[ $? == 0 ]]; then
    printf "\nSuccess file name found: $filename\n"
else
    >&2 printf "\nError! File name not found\n"
    exit 1
fi

#unzip transaction file
bunzip2 -f $filename

if [[ $? == 0 ]]; then
    printf "\nFile has been unzippped!\n"
else
    >&2 printf "\nError! File has failed to be unzipped\n"
    exit 1
fi

#now we need to remove the .bz2 from the file name
echo $filename > $GARBAGE
filename=$(sed 's/.bz2//' $GARBAGE) 

if [[ $? == 0 ]]; then
    printf "\nNew file name found: $filename\n"
else 
    >&2 printf "\nError! new file name not found."
    exit 1
fi

#remove header record from the transaction file
tail -n +2 $filename > $GARBAGE

if [[ $? == 0 ]]; then
    printf "\nNice! header removed from file.\n"
    cat $GARBAGE > $filename
else
    >&2 printf "\nHeader failed to be removed\n"
    exit 1
fi

#convert all the text in transaction file to lower case
tr 'A-Z' 'a-z' < $filename > $GARBAGE

if [[ $? == 0 ]]; then
    printf "\nText has succesfully been converted to lower case\n"
    cat $GARBAGE > $filename
else
    >&2 printf "\nError! text couldn't be converted to lower case\n"
    exit 1
fi

#convert gender fields to all "f", "m", and "u"
#error finding built-in to script files
if ./fixgender.sh $filename; then
    printf "\nSuccessfully normalized gender field\n"
else
    >&2 printf "\nFailed to normalize gender field\n"
    exit 1
fi

#filter out all the records from the transcation file from "state" field that do not have a state or contain "NA". Remove them from original and quarentine them in exceptions.csv
if ./filterstates.sh $filename; then
    printf "\nSuccessfully normalized state field and created exceptions.csv\n"
else
    >&2 printf "\nFailed to normalize state field\n"
    exit 1
fi

#Remove the $ sign in the transaction file from the "purchase_amt" field
if ./removedollar.sh $filename; then
    printf "\nSuccessfully removed dollar signs from purchase amount field\n"
else
    >&2 printf "\nFailed to remove dollar signs from purchase amount field\n"
    exit 1
fi

#sort transaction file by customerID. format shouldn't change. final transaction file should be called transaction.csv
if sort -t, -k 1,1 $filename > $GARBAGE; then
    printf "\nTransaction file sort successful\n"
    cat $GARBAGE > transaction.csv
else
    >&2 printf "\nTransaction file sort failed\n"
    exit 1
fi


#generate a summary file using transaction.csv. look at .pdf for pertitent details
./customerid.sh $1



#take out trash
trap garbageCollector 1 2 3 6

exit 0
