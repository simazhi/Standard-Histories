#working directory
setwd("/Users/Thomas/Documents/TacoRscript/")
getwd()




### install packages
#install.packages("jiebaR")
#install.packages('stringr')
#require('jiebaR')
#require('stringr')

library(jiebaR)
library(stringr)

### read in materials
corpus <- scan('/Users/Thomas/Documents/TacoRscript/Shiji_biao.txt', 
               what='char', encoding='UTF-8')
masterlist <- unique(scan('masterlist.txt', what='char'))
rejectlist <- 'rejected.txt'



### jieba segmentation on corpus
cutter = worker("tag", stop_word = rejectlist)

# using masterlist into jieba dict to do the segmentation
for (i in 1:length(masterlist)){
  new_user_word(cutter,masterlist[i],"IDEO")
}

# segmentation
result_segment = cutter[corpus]
result_segment1 <- result_segment


### segmentation with result output format
tag_name <- names(result_segment)
position <- grep('IDEO', tag_name, perl=T)

# concatenate masterlist with _IDEO
for (i in 1:length(position)){
  result_segment[[position[i]]][1] <- paste(result_segment[[position[i]]][1], 'IDEO', sep='_')
}

seg_corpus <- as.vector(result_segment)

# output seg_corpus to a txt file
write.table(seg_corpus, 'seg_corpus.txt', quote=F, row.names = F, 
            col.names = F)


# ------------ candidate wordlist ---------------#
candidate_corpus <- as.vector(result_segment1)
candidate_corpus <- candidate_corpus[-c(1:29)]
candidate_corpus <- paste(candidate_corpus, collapse='')

seg_candidate <- unlist(strsplit(candidate_corpus,split=''))

candidatelist <- c()
for (i in 1:length(seg_candidate)){
  if (i != length(seg_candidate)){
    if (seg_candidate[i]==seg_candidate[i+1]){
      candidatelist[i] <- paste(seg_candidate[i], seg_candidate[i+1], sep='')
    }else{
      next
    }
  }
}


candidatelist <- candidatelist[!is.na(candidatelist)]
same <- setdiff(unique(candidatelist), masterlist)

write.table(same, 'candidatelist.txt', quote=F, sep='\n',
            row.names = F, col.names = F)

