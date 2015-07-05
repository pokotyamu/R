#library(RMySQL)
#md <- dbDriver("MySQL")
#dbc <- dbConnect(md, dbname="psp",user="root",host="localhost",password="root")

#
# 条件指定の抽出
# 各ST_IDから、各project_idでsubmit_idが最大なものを抜き出す
# subに抽出後のデータがまとめられる
#
data <- dbGetQuery(dbc,"select * from defectLog")

max_subID <- function(dataLog,class_id){
  sub <- data.frame()
  cl_Log <- dataLog[which(dataLog$CLASS_ID == class_id),] #１クラス分
  for(st_id in min(cl_Log$ST_ID):max(cl_Log$ST_ID)){
    st_Log <- cl_Log[which(cl_Log$ST_ID == st_id),] #１人分
    for(pro_id in min(st_Log$Project_ID):max(st_Log$Project_ID)){
      pro_Log <- st_Log[which(st_Log$Project_ID == pro_id),] #１課題分
      sub <- rbind(sub,pro_Log[which(pro_Log$SUBMIT_ID == max(pro_Log$SUBMIT_ID)),][1,]) #SUBMITION_IDが最大のものを１つ抽出
    }
  }
  return (sub)
}



#max(DB抽出("x軸","y軸","条件"));
#
# それぞれの個数を集計
#
project_id <- data.frame()
submit_id <- data.frame()
count <- data.frame()
for(pro_id in min(dataLog$Project_ID):max(dataLog$Project_ID)){
  tb <- table(sub$SUBMIT_ID[which(sub$Project_ID==pro_id)])
  for(i in 1:max(dataLog$SUBMIT_ID)){
    project_id <- rbind(project_id,pro_id)
    submit_id <- rbind(submit_id,i)
    if(is.na(as.vector(tb[i]))){
      count <- rbind(count,0)
    }else{
      count <- rbind(count,as.vector(tb[i]))
    }
  }
}
recount <- data.frame(project_id,submit_id,count)
names(recount) <- c("PROJECT_ID","SUBMIT_ID","COUNT")

#
# グループ化のためにデータフレームからマトリックスに変更
#
convert_bar_data <- function(dataLog){
  mat_count <- matrix(0,max(dataLog$SUBMIT_ID),max(dataLog$Project_ID)-398)
  rownames(mat_count)<-c(min(dataLog$SUBMIT_ID):max(dataLog$SUBMIT_ID))
  colnames(mat_count)<-c(min(dataLog$Project_ID):max(dataLog$Project_ID))
  for(i in min(dataLog$Project_ID):max(dataLog$Project_ID)){
    mat_count[,i-398] <- recount$COUNT[which(recount$PROJECT_ID == i)]
  }
}

max_subID(data,2014)


#
# グラフ化
#
barplot(
  mat_count,
  beside = T,
  ylim = c(0,5),
  legend.text = row.names(mat_count),
  las=1,#ラベルの向きの変更
  main = "Count Resubmition"
)
box("plot",lty=1)#枠線