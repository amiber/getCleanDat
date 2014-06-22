#load training set X  data
xtr<-read.table('X_train.txt')
#load test set X data
xts<-read.table('X_test.txt')
#load training & then test sets subject data
sbtr<-read.table('subject_train.txt')
sbts<-read.table('subject_test.txt')
#load training & then test sets Y data
ytr<-read.table('y_train.txt')
yts<-read.table('y_test.txt')
#combine all columns of train data
dtr<-cbind(xtr,sbtr,ytr)
#combine all columns of test data
dts<-cbind(xts,sbts,yts)
#obtain the final dataframe (not cleaned yet)
dt<-rbind(dtr, dts)
#read the features file
ftr<-read.table('features.txt', stringsAsFactors =F) 
#renaming the 1:561 column names
for (i in 1:561)
    {
        names(dt)[i]<-ftr[i,2]
    }
#renaming the 562:563 column names
names(dt)[562]<-'subject'
names(dt)[563]<-'activity'    
#extract mean and std columns only
dtmn<-subset(dt,select=grep('mean\\()',names(dt),ignore.case=T, value=T))
dtsd<-subset(dt,select=grep('std',names(dt),ignore.case=T, value=T))
#all final 66 columns + subject + activity
dtTemp<-cbind(dtmn,dtsd)
dtTemp$subject<-dt$subject
dtTemp$activity<-dt$activity
dt<-dtTemp
#take away the parenthesis from the names and some names cleaning
names(dt)<-gsub('\\()','',names(dt), ignore.cas=T)
names(dt)<-gsub('fBodyBody','fBody',names(dt), ignore.cas=T)
names(dt)<-gsub('mean','Mean',names(dt), ignore.cas=T)
names(dt)<-gsub('std','Std',names(dt), ignore.cas=T)

#We now want a mean for each column grouping by activity (6 activities), and subject (30 activities)
dt<-aggregate(dt[names(dt)[1:66]],by=dt[c('subject','activity')],mean,na.rm=T)
#relabel the Y's
dt$activity[dt$activity==1]<-'WALKING'
dt$activity[dt$activity==2]<-'WALKING_UPSTAIRS'
dt$activity[dt$activity==3]<-'WALKING_DOWNSTAIRS'
dt$activity[dt$activity==4]<-'SITTING'
dt$activity[dt$activity==5]<-'STANDING'
dt$activity[dt$activity==6]<-'LAYING'
write.table(dt,"tidydata.txt")