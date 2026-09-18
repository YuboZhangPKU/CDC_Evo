library(ggmsa)

fai<-"CDC.pep.align2.fasta"

pdf(file = "Rdo_CDC_Loop1.pdf",width = 10,height = 3)
ggmsa(fai, 735, 740, color = "Chemistry_AA", font = "TimesNewRoman", char_width = 0.5, seq_name = TRUE)+geom_seqlogo()
dev.off()

pdf(file = "Rdo_CDC_UDP.pdf",width = 10,height = 3)
ggmsa(fai, 703, 715, color = "Chemistry_AA", font = "TimesNewRoman", char_width = 0.5, seq_name = TRUE)+geom_seqlogo()
dev.off()
