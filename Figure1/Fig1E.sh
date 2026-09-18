#!shell
date
version

#specify data file, p-value threshold, # of threads to use, and log file
load -i IPR_M_SUPERFAMILY_count_CAFE -p 0.01 -t 16 -l Nci_IPR_M_SUPERFAMILY_log.txt

#the phylogenetic tree structure with branch lengths
tree (Dmel:354.228718,(((Hvit:174.718571,(Ido:117.149319,(Nap:12.838046,Nci:12.838046):104.311273):57.569252):65.762845,Ofa:240.481416):31.691287,(Lst:131.985751,Nlu:131.985751):140.186952):82.056015)

lambda -s -t (1,(((1,(1,(1,1)1)1)1,1)1,(1,1)1)1)

# generate a report
report Nci_IPR_M_SUPERFAMILY_report.txt

