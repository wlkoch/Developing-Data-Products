library(shiny)
library(UsingR)
library(rpart)


shinyServer(
        function(input, output) {               
                
                mainData <- read.csv("IneqDataset.csv")
                                
                meanGini <- mean(mainData$GiniCoeff, na.rm = TRUE)
                meanPov90_10 <- mean(mainData$PerRatio90_10, na.rm = TRUE)
                meanPovChild2Par <- mean(mainData$ChildPovRatesTwoParentFam_50_percent, na.rm = TRUE)
                meanPovChildSingMother <- mean(mainData$ChildPovRatesSingMothFam_50_percent, na.rm = TRUE)
                               
                
                 output$newScatterplot <- renderPlot({
                         
                        ctry <- input$id1 
                        meas <- input$id2
                        wave <- input$wave
                        
                        singleCountry <- subset(mainData, Country == ctry)
                        year <- singleCountry[wave,]$Year
                        
                        if (meas == "GiniCoeff") { 
                                ineqMeas <- singleCountry$GiniCoeff
                                ineqDiff <- singleCountry[wave,]$GiniCoeff - meanGini
                                ineqMeas_ylim = c(0.15, 0.50)
                                main_label <- paste(ctry, ": Gini Coefficients")
                                y_label <- 'Gini Coefficient'
                        } else if (meas == "PerRatio90_10") {
                                ineqMeas <- singleCountry$PerRatio90_10 
                                ineqDiff <- singleCountry[wave,]$PerRatio90_10 - meanPov90_10
                                ineqMeas_ylim = c(2.0, 9.50)
                                main_label <- paste(ctry, ": Income Ratio of Households in the 90th to the 10th percentile")
                                y_label <- 'Income Ratio: 90/10 percentile'
                                
                        } else if (meas == "ChildPovRatesTwoParentFam_50_percent") {
                                ineqMeas <- singleCountry$ChildPovRatesTwoParentFam_50_percent
                                ineqDiff <- singleCountry[wave,]$ChildPovRatesTwoParentFam_50_percent - meanPovChild2Par
                                ineqMeas_ylim = c(1.0, 25.0)   
                                main_label <- paste(ctry, ": Child Poverty Rates - Two-parent Household (50% of Poverty Level)")
                                y_label <- 'Child Poverty Rates: Two-parent HH'
                                
                        } else {
                                ineqMeas <- singleCountry$ChildPovRatesSingMothFam_50_percent
                                ineqDiff <- singleCountry[wave,]$ChildPovRatesSingMothFam_50_percent - meanPovChildSingMother
                                ineqMeas_ylim = c(4.0, 60.0)    
                                main_label <- paste(ctry, ": Child Poverty Rates - Single-Mother Household (50% of Poverty Level)")
                                y_label <- 'Child Poverty Rates: Single-Mother HH'   
                                
                        }
                        
                        plot(singleCountry$WaveNum,
                             ineqMeas,
                             ylim = ineqMeas_ylim,
                             type = 'l',
                             lwd = 3,
                             xlab = 'Wave',
                             ylab = y_label,
                             main = main_label,
                             sub ="Data source: Luxembourg Income Study Database"
                             )
                                                
                        firstWave <- singleCountry[1,4]
                        lastWave <- singleCountry[nrow(singleCountry), 4]
                        
                        if (wave < firstWave) {
                                abline(v=firstWave, lwd = 2, col = "green")
                        }  else if (wave > lastWave) {
                                abline(v=lastWave, lwd = 2, col = "purple")
                        } else {
                                abline(v=wave, lwd = 2, col = "blue")
                        }
                        
                        meanDiff <- paste("Deviation from cohort mean: ", round(ineqDiff, digits = 2))
                        output$meanDiff <- renderPrint({meanDiff})
                        waveYear <- paste("Wave year: ", year)
                        output$waveYear <- renderPrint({waveYear})
                        
                })
                
        }
)









