library(datasets)
library(lubridate)
library(forecast)
data("EuStockMarkets")

shinyServer(
  function(input, output) {
    EuSM <- data.frame(Year = c(floor(time(EuStockMarkets) + 1e-6)), 
                       Day = c(cycle(EuStockMarkets)),
                       EuStockMarkets)
    EuSM$Date <- date_decimal(EuSM$Year+EuSM$Day/260)
    
    output$EUForecastHist <- renderPlot({
      iYear <- input$Year
      iMarket <- input$Market
      Jan2nd <- rep(rep(c(TRUE,FALSE),c(1,259)),1999-iYear)
      
      tickMarks = seq(as.Date(EuSM[EuSM$Day==1,"Date"][1]), by="years", length=10)
      EuSM <- EuSM[EuSM$Year<iYear,]
      EuSMts <- ts(EuSM[,iMarket],start=c(EuSM$Year[1],EuSM$Day[1]),frequency=260)
      
      fc <- forecast(holt(EuSMts,h=260*(1999-iYear)+1), 260*(1999-iYear)+1)
      suppressWarnings(plot(fc, xaxt="n",main=paste("Forecast of",iMarket),ylim=c(1000,7000)))
      axis(1, at = decimal_date(tickMarks), labels = format(tickMarks, "%Y"))
    })
    output$EUForecastTable <- renderTable({
      iYear <- input$Year
      iMarket <- input$Market
      Jan2nd <- rep(rep(c(TRUE,FALSE),c(1,259)),1999-iYear)

      EuSM <- EuSM[EuSM$Year<iYear,]
      EuSMts <- ts(EuSM[,iMarket],start=c(EuSM$Year[1],EuSM$Day[1]),frequency=260)
    
      fc <- forecast(holt(EuSMts,h=260*(1999-iYear)+1), 260*(1999-iYear)+1)
      Years <- iYear:1999
      Low95 <- subset(fc$lower[,2],subset=Jan2nd)
      Low80 <- subset(fc$lower[,1],subset=Jan2nd)
      Means <- subset(fc$mean,subset=Jan2nd)
      High95 <- subset(fc$upper[,2],subset=Jan2nd)
      High80 <- subset(fc$upper[,1],subset=Jan2nd)
      df <- data.frame(Low95,Low80,Means,High80,High95)
      rownames(df) <- Years
      df
    })
    output$TableHeader <- renderText({
      paste("<h2>Holt Forecast Intervals & Mean for",input$Market,"Index</h2>")
    })
  }
)