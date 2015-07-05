#
# 欠陥情報の変更をカウント
#

dataLog <- dbGetQuery(dbc,"select * from defectLog")
ch_defect <- data.frame()
for(pro_id in min(dataLog$Project_ID):max(dataLog$Project_ID)){
  sp_project <- dataLog[which(dataLog$Project_ID==pro_id),]
  for(st_id in min(sp_project$ST_ID):max(sp_project$ST_ID)){
    sp_st <- sp_project[which(sp_project$ST_ID==st_id),]
    for(i in 1:nrow(sp_st)){
      target <- sp_st[which(sp_st$Defect_ID == sp_st$Defect_ID[i]),]
      if(sp_st$SUBMIT_ID[i] > 1 && nrow(target)> 1){
        ch_defect <- rbind(ch_defect,target[1,])
      }
    }
  }
}

print(ch_defect)

for(pro_id in min(ch_defect$Project_ID):max(ch_defect$Project_ID)){
  
}