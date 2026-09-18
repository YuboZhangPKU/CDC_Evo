# _*_ coding: UTF-8 _*_
# Version information START --------------------------------------------------
VERSION_INFO = \
    """
    Author: ZHANG YUBO

    Version-01:
        2020-10  Converting genewise GFF3 to EVM alignments
    """
# Version information END ----------------------------------------------------

import argparse

###############################################################################
# read parameters
###############################################################################
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="format conversion")
    parser.add_argument("-i", "--Input",
                        help="Input GFF3 file", required=True)
    parser.add_argument("-o", "--Output",
                        help="Output file", required=False)
    parser.add_argument("-e", "--Exclude",
                        help="Exclude gene list", required=False)

    # -------------------------------------------------------------------->>>>>
    # load the parameters
    # -------------------------------------------------------------------->>>>>
    ARGS = parser.parse_args()
    if ARGS.Exclude != None:
        ExcludeGeneList = ARGS.Exclude.split(',')
    else:
        ExcludeGeneList = []

    with open (ARGS.Input, 'r') as fin:
        lines = fin.readlines()

    GeneList = []
    GeneDict = {}
    GeneCountDict = {}
    with open (ARGS.Output, 'w') as fout:
        for line in lines:
            line = line.strip()
            if line[0:3] == '###':
                Target = line[3:]
                if Target in GeneList:
                    GeneCountDict[Target] += 1
                    Target += '_' + str(GeneCountDict[Target])
 
                else:
                    GeneCountDict[Target] = 1
                GeneList.append(Target)
                #fout.write("\n")
                score = 0

            elif 'match' in line:
                flag = False
                if float(line.split('\t')[5]) > score:
                    score = float(line.split('\t')[5])
                    flag = True
                    GeneDict[Target] = {'gene':line, 'cds':[]}

            elif 'cds' in line and flag:
                line = line.split('\t')
                Region_start = int(line[0].rsplit('_', 1)[1])
                Start = int(line[3]) + Region_start - 1
                End = int(line[4]) + Region_start - 1
                if line[6] == '-':
                    Start, End = End, Start
                GeneDict[Target]['cds'].append([Start, End])

        for Gene in GeneList:
            if Gene in GeneDict.keys() and Gene.split('_')[0] not in ExcludeGeneList:
                line = GeneDict[Gene]['gene']
                line = line.split('\t')
                Chr = line[0].rsplit('_', 1)[0]
                Region_start = int(line[0].rsplit('_', 1)[1])
                Start = int(line[3]) + Region_start - 1
                End = int(line[4]) + Region_start - 1
                if line[6] == '-':
                    Start, End = End, Start       
                fout.write("%s\tGeneWise\tgene\t%s\t%s\t%s\t%s\t.\tID=%s_g;Target=%s\n" % (Chr, Start, End, line[5], line[6], Gene, Gene))
                fout.write("%s\tGeneWise\tmRNA\t%s\t%s\t%s\t%s\t.\tID=%s;Parent=%s_g\n" % (Chr, Start, End, line[5], line[6], Gene, Gene))
                len = 0
                for CDS in GeneDict[Gene]['cds']:
                    if len % 3 == 0:
                        frame = 0
                    else:
                        frame = 3 - (len % 3)
                    fout.write("%s\tGeneWise\tCDS\t%s\t%s\t%s\t%s\t%s\tID=%s.cds;Parent=%s\n" % (Chr, CDS[0], CDS[1], '.', line[6], frame, Gene, Gene))
                    len += CDS[1] - CDS[0] + 1
                fout.write("\n")
