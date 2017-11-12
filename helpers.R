#setwd("C:/Users/mateo/Desktop/school/math 399/shiny")
#library(R.utils)
#library(XML)
#library(RColorBrewer)
#library(maps)
#library(stringr)
#factbookURL <- "http://jmatchparser.sourceforge.net/factbook/data/factbook.xml.gz"
#download.file(factbookURL, paste(getwd(), "/factbook.xml.gz", sep=""), cacheOK=TRUE)
#gunzip("factbook.xml.gz", overwrite=TRUE)


map_it<-function(palette="YlOrRd",field="f2091"){
  
  factbookDoc <- xmlParse("factbook.xml")
  latlong = read.csv("latlong.csv",header = TRUE)
  latlong$ctry= tolower(latlong$ctry)
  
  path<-"//field[@id='f2091']/rank"
  
  str_sub(path,14,-8)<-field
  
  
  rankNodes_2 <-getNodeSet(factbookDoc,path)
  infNum  <-as.numeric(sapply(rankNodes_2, xmlGetAttr, "number"))
  infCtry <-sapply(rankNodes_2, xmlGetAttr, "country")
  infMortDF <-data.frame(infMort = infNum, ctry=infCtry, stringsAsFactors = FALSE)
  poploc <-getNodeSet(factbookDoc, "//field[@id='f2119']/rank")
  popDF  <-data.frame(pop = as.numeric(sapply(poploc, xmlGetAttr, "number")),ctry =  sapply(poploc, xmlGetAttr, "country"))
  
  IMPop<-merge(infMortDF,popDF)
  allCtryData<-merge(IMPop,latlong)
  
  
  allCtryData$InfMortDiscrete = cut(allCtryData$infMort,breaks=5)
  summary(allCtryData$InfMortDiscrete)
  
  cols = brewer.pal(9,palette)[c(1,2,4,6,7)]
  allCtryData$colr = cols[allCtryData$InfMortDiscrete]
  
  fieldNames<-switch(field,
                     "f2091"="Infant Mortalilty Rate","f2225"="Health Expenditures",
                     "f2228"="Obesity - Adult Prevalence","f2054"="Birth Rate",
                     "f2066"="Death Rate","f2223"="Maternal Mortality Rate","f2089"="Idustrial Production Growth Rate",
                     "f2153"="Internet Users","f2229"="Unemployment; Age 15-24"
  )
  
  world = map(database="world",col = '#8cff66', fill = TRUE)
  with(allCtryData,symbols(longitude,latitude, circles = sqrt(pop)/4000,
                           inches =FALSE, add = TRUE,fg=colr,bg=colr))
  legend(x=-150,y=0,legend=levels(allCtryData$InfMortDiscrete),
         bty='o',fill=cols,cex=.5,title =fieldNames )
  
  
}
#map_it(palette="Set1", field="f2225")

