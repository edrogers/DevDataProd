shinyUI(fluidPage(
  titlePanel("Adjustable Forecast Plotter"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create a forecast for one of four different European Stock Indices, with an adjustable start date"),
      radioButtons('Market','Choose a Market Index',c("DAX","SMI","CAC","FTSE")),
      sliderInput('Year', 'Forecast Starting Year',value =1994, min = 1992, max = 1998, step = 1, sep="")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot",plotOutput('EUForecastHist')),
        tabPanel("Summary",
                 h2("Adjustable Holt Forecast Plotter for European Stock Market Data"),
                 p("Users can manipulate the start date for a forecast of stock market index values. Four different European indices are available to forecast, with data running from mid-1991 to the end of 1998. Forecasts run to 1999, regardless of start date."),
                 p("On the 'Table' tab, users can see the mean and the 80% and 95% confidence intervals for the forecast on the first business day of each year in the forecast."),
                 h3("Daily Closing Prices of Major European Stock Indices, 1991–1998"),
                 p("Contains the daily closing prices of major European stock indices: Germany DAX (Ibis), Switzerland SMI, France CAC, and UK FTSE. The data are sampled in business time, i.e., weekends and holidays are omitted."),
                 p("The data were kindly provided by Erste Bank AG, Vienna, Austria.")),
        tabPanel("Table",
                 htmlOutput("TableHeader"),
                 tableOutput("EUForecastTable"))
      )
    )
  )
))