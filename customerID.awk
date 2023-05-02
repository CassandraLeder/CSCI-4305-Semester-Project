#!/bin/gawk

BEGIN { FS=OFS="," }
{	
	for(i = 0; i < NF; i++) {
		customer[i,0] = $1
		for(j = 1; j < NF + 1; j++) {
			customer[i,j] = $6
		}
	}
}
{

	for(i = 0; i < NF; i++) {
		for(j = 1; j < NF + 1; j++) {
			while(customer[i,0] == customer[j,0]) {
				total[i] += customer[i,j]
				j++;
			}
			
			total[i] += customer[i,j]
		}
	}
}
END {for(i = 0; i < NF; i++) { for(j = 1; j < NF + 1; j++) {print customer[i,j]} print total[i]}}	
