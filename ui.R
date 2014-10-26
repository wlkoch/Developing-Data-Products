
library(shiny)
library(rpart)


mainData <- read.csv("IneqDataset.csv")

meanGini <- mean(mainData$GiniCoeff, na.rm = TRUE)
meanPov90_10 <- mean(mainData$PerRatio90_10, na.rm = TRUE)
meanPovChild2Par <- mean(mainData$ChildPovRatesTwoParentFam_50_percent, na.rm = TRUE)
meanPovChildSingMother <- mean(mainData$ChildPovRatesSingMothFam_50_percent, na.rm = TRUE)

shinyUI(pageWithSidebar(
  headerPanel("Cross-national Income Inequality Comparisons"),
  sidebarPanel(
#         h5('Select Country'),
        radioButtons("id1", "Select Country",
                                c("Finland" = "Finland",
                                "Germany" = "Germany",
                                "Israel" = "Israel",
                                "Mexico" = "Mexico",
                                "Poland" = "Poland",
                                "Slovak Republic" = "Slovak Republic",
                                "Spain" = "Spain",
                                "United Kingdom" = "United Kingdom",
                                "United States" = "United States"),
                                selected = "Finland"),
        radioButtons("id2", "Select Inequality measure",
                        c("Gini Coefficient" = "GiniCoeff",
                        "Income Percentile Ratio (90/10)" = "PerRatio90_10",
                        "Children Poverty Rates - Two-Parent HH (50%)" = "ChildPovRatesTwoParentFam_50_percent",
                        "Children Poverty Rates - Single-Mother HH (50%)" = "ChildPovRatesSingMothFam_50_percent"),
                        selected = "GiniCoeff"),
        sliderInput('wave', 'Select Wave',value = 1, min = 1, max = 8, step = 1.0,)
  ),
  mainPanel(
    plotOutput('newScatterplot'),
    verbatimTextOutput("meanDiff"),
    verbatimTextOutput("waveYear"),  
    p(em("Documentation:",a("Cross-national Income Inequality",href="index.html")))

  )
))





# Original code

#shinyUI(pageWithSidebar(
#  headerPanel("Example plot"),
#  sidebarPanel(
#    sliderInput('mu', 'Guess at the mu',value = 70, min = 60, max = 80, step = 0.05,)
#  ),
#  mainPanel(
#    plotOutput('newHist')
#  )
#))



