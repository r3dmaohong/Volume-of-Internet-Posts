rm(list = ls()) #Remove all objects in the environment
gc() ##Free up the memory

original_path <- getwd()
setwd(file.path('Volume-of-Internet-Posts'))
dir.create('\\output', showWarnings = FALSE)

start.time = gsub(":","_",Sys.time())

##Web Crawler for ptt, lineq, and yahoo answer...
source('.\\rscript\\ptt_jiebar.R', print.eval  = TRUE)
source('.\\rscript\\lineq_jiebar.R', print.eval  = TRUE)
source('.\\rscript\\yahoo++_jiebar.R', print.eval  = TRUE)

##jiebar's main program
source('.\\rscript\\function\\jiebar-main.R', print.eval  = TRUE)

n = '2016���Ҹ��I'
dir.create(file.path('output\\',n), showWarnings = FALSE)

if(T){
  ##2016���Ҹ��I
  ##���|Ū�������n�� ���~
  
  ##url,forum name, min=1, max=9999999, start.time=unsetted
  lineq_crawler_jiebar('http://lineq.tw/search/question?q=%E8%90%BD%E9%BB%9E&sort=date&sel=all&page=','lineq���Ҹ��I2016',,10,start.time)
  ptt_crawler_jiebar('https://www.ptt.cc/bbs/SENIORHIGH/index',,1968,,start.time)
  yahoo_crawler_jiebar('https://tw.answers.yahoo.com/search/search_result?p=��j&s=','yahoo��j',1,200,start.time)
}



##��X�Ҧ��ɮ�
sc_or_com <- function(n,path=paste0("D:\\abc\\wjhong\\projects\\internet_volume\\output\\",start.time)){
  if(n=='�Ǯ�'){
    ##�ǮմN�ഫ�M�᭫�s��@��freq
    setwd(path)
    csv_list = list.files(pattern="*.csv")
    for(i in 1:length(csv_list)){
      temp = read.csv(csv_list[i],stringsAsFactors=F)
      colnames(temp) = c('���J','����')
      if(i==1){
        all_temp = temp
      }else{
        all_temp = rbind(all_temp,temp)
      }
    }
    
    tmp2 = read.csv('D:\\abc\\wjhong\\projects\\school_performence_analysis\\�ǮզW�٥��W�ƪ���.csv',stringsAsFactors=F)
    tmp2[,1] = tolower(tmp2[,1])
    ##�^��𱼦n�F�ӧt�k
    tmp2 = tmp2[which(!grepl("[a-z]",tmp2[,1])),]
    all_temp$out=''
    for(i in 1:nrow(all_temp)){
      if(toString(tmp2[which(tmp2[,1]==all_temp[i,1]),2])!=''){
        all_temp[i,1] = tmp2[which(tmp2[,1]==all_temp[i,1]),2][1]
        print(all_temp[i,1])
      }else if(toString(tmp2[which(tmp2[,2]==all_temp[i,1]),2])!=''){
        
      }else{
        all_temp$out[i] = 1
      }
    }
    ##�@����
    write.csv(all_temp[which(all_temp$out==1),],'����\\���C�J���j�ǦW�٨Ѭd��.csv',row.names=F)
    
    all_temp = all_temp[which(all_temp$out!=1),]
    
    
    library(plyr)
    temp = ddply(all_temp , '���J', summarize, �`����=sum(����))
    temp = temp[order(-temp$�`����),]
    
    now = format(Sys.time(), "%Y_%m_%d_%H_%M_%OS")
    
    write.csv(temp,paste0('union_output/',now,'��X���J���G.csv'),row.names=F)
    temp = temp[which(temp[,1]!=''),]
    return(temp)
  }else if(n=='���q'){
    ##���q�N������ഫ�F
    ##�H�K�����D
    setwd(path)
    csv_list = list.files(pattern="*.csv")
    for(i in 1:length(csv_list)){
      temp = read.csv(csv_list[i],stringsAsFactors=F)
      colnames(temp) = c('���J','����')
      if(i==1){
        all_temp = temp
      }else{
        all_temp = rbind(all_temp,temp)
      }
    }
    
    library(plyr)
    temp = ddply(all_temp , '���J', summarize, �`����=sum(����))
    temp = temp[order(-temp$�`����),]
    
    now = format(Sys.time(), "%Y_%m_%d_%H_%M_%OS")
    dir.create('union_output', showWarnings = FALSE)
    write.csv(temp,paste0('union_output/',now,'��X���J���G.csv'),row.names=F)
    
    comp_name = read.csv('D:\\abc\\wjhong\\projects\\school_performence_analysis\\__�B�z�᤽�q�W��.csv',stringsAsFactors=F)
    tmp = temp
    tmp$���� = ''
    for(i in 1:nrow(tmp)){
      if(toString(which(tolower(comp_name$company)==tmp$���J[i]))!=''){
        tmp$����[i] = comp_name$�̲פ�ﵲ�G[which(tolower(comp_name$company)==tmp$���J[i])][1]
      }else if(toString(which(tolower(comp_name$�̲פ�ﵲ�G)==tmp$���J[i]))!=''){
        tmp$����[i] = comp_name$�̲פ�ﵲ�G[which(tolower(comp_name$�̲פ�ﵲ�G)==tmp$���J[i])][1]
      }else{
        tmp$����[i] = ''
      }
    }
    school_name = read.csv('D:\\abc\\wjhong\\projects\\school_performence_analysis\\�ǮզW�٥��W�ƪ���.csv',stringsAsFactors=F)
    for(i in 1:nrow(tmp)){
      if(toString(which(tolower(school_name$trim���l)==tmp$���J[i]))!='' & tmp$����[i]==''){
        tmp$����[i] = school_name$������[which(tolower(school_name$trim���l)==tmp$���J[i])][1]
      }else if(toString(which(tolower(school_name$������)==tmp$���J[i]))!='' & tmp$����[i]==''){
        tmp$����[i] = school_name$������[which(tolower(school_name$������)==tmp$���J[i])][1]
      }else{
      }
    }
    remove_text = read.table("D:\\abc\\wjhong\\projects\\internet_volume\\���簣�r��.txt")
    tmp = tmp[which(!tmp[,1] %in% remove_text$V1),]
    ##�O�d��r��
    write.csv(tmp,paste0('union_output/',now,'�O�d��r�ꤽ�q��ӵ��J�W���ഫ�ᵲ�G.csv'),row.names=F)
    
    tmp = tmp[which(tmp$����!=''),]
    tmp = ddply(tmp , '����', summarize, �`����=sum(�`����))
    tmp = tmp[order(-tmp$�`����),]
    tmp = tmp[which(tmp$����!="�L�k�P�_"),]
    
    write.csv(tmp,paste0('union_output/',now,'���q��ӵ��J�W���ഫ�ᵲ�G.csv'),row.names=F)
    
    return(temp)
  }else{
    n <- readline(prompt="��J[�Ǯ�] or [���q]: ")
    sc_or_com(n)
  }
}

n <- readline(prompt="��J[�Ǯ�] or [���q]: ")
output <- sc_or_com(n,'D:\\abc\\wjhong\\projects\\internet_volume\\output\\2016-04-07 14_06_45')



##�j�ǦW��
college = read.table('D:\\abc\\wjhong\\projects\\internet_volume\\�j�ǦW��.txt')

##�줣�b�j�ǦW�椺
nc = output[which(!(output[,1] %in% college[,1])),]
write.csv(nc,'union_output/20160615-2��j��X���J���G.csv',row.names=F)


##���q
comp = read.table('D:\\abc\\wjhong\\projects\\internet_volume\\���簣�r��.txt')

##�줣�b�j�ǦW�椺
nc = output[which(!(output[,1] %in% comp[,1])),]
write.csv(nc,'union_output/20160408�A�ȷ~��X���J���G.csv',row.names=F)


##��ʾ�z��
if(F){
  path<-paste0("D:\\abc\\wjhong\\projects\\internet_volume\\output\\���q��ʾ�z�U�ɮ�")
  setwd(path)
  csv_list = list.files(pattern="*.csv")
  for(i in 1:length(csv_list)){
    temp = read.csv(csv_list[i],stringsAsFactors=F)
    colnames(temp) = c('���J','����')
    if(i==1){
      all_temp = temp
    }else{
      all_temp = rbind(all_temp,temp)
    }
  }
  
  library(plyr)
  temp = ddply(all_temp , '���J', summarize, �`����=sum(����))
  temp = temp[order(-temp$�`����),]
  
  now = format(Sys.time(), "%Y_%m_%d_%H_%M_%OS")
  dir.create('union_output', showWarnings = FALSE)
  write.csv(temp,paste0('union_output/',now,'��X���J���G.csv'),row.names=F)
  
  comp_name = read.csv('D:\\abc\\wjhong\\projects\\school_performence_analysis\\__�B�z�᤽�q�W��.csv',stringsAsFactors=F)
  tmp = temp
  tmp$���� = ''
  for(i in 1:nrow(tmp)){
    if(toString(which(tolower(comp_name$company)==tmp$���J[i]))!=''){
      tmp$����[i] = comp_name$�̲פ�ﵲ�G[which(tolower(comp_name$company)==tmp$���J[i])][1]
    }else if(toString(which(tolower(comp_name$�̲פ�ﵲ�G)==tmp$���J[i]))!=''){
      tmp$����[i] = comp_name$�̲פ�ﵲ�G[which(tolower(comp_name$�̲פ�ﵲ�G)==tmp$���J[i])][1]
    }else{
      tmp$����[i] = ''
    }
  }
  #school_name = read.csv('D:\\abc\\wjhong\\projects\\school_performence_analysis\\�ǮզW�٥��W�ƪ���.csv',stringsAsFactors=F)
  #for(i in 1:nrow(tmp)){
  #  if(toString(which(tolower(school_name$trim���l)==tmp$���J[i]))!='' & tmp$����[i]==''){
  #    tmp$����[i] = school_name$������[which(tolower(school_name$trim���l)==tmp$���J[i])][1]
  #  }else if(toString(which(tolower(school_name$������)==tmp$���J[i]))!='' & tmp$����[i]==''){
  #    tmp$����[i] = school_name$������[which(tolower(school_name$������)==tmp$���J[i])][1]
  #  }else{
  #  }
  #}
  remove_text = read.table("D:\\abc\\wjhong\\projects\\internet_volume\\���簣�r��.txt")
  tmp = tmp[which(!tmp[,1] %in% remove_text$V1),]
  ##�O�d��r��
  write.csv(tmp,paste0('union_output/',now,'�O�d��r�ꤽ�q��ӵ��J�W���ഫ�ᵲ�G.csv'),row.names=F)
  
  tmp = tmp[which(tmp$����!=''),]
  tmp = ddply(tmp , '����', summarize, �`����=sum(�`����))
  tmp = tmp[order(-tmp$�`����),]
  tmp = tmp[which(tmp$����!="�L�k�P�_"),]
  
  write.csv(tmp,paste0('union_output/',now,'���q��ӵ��J�W���ഫ�ᵲ�G.csv'),row.names=F)
}