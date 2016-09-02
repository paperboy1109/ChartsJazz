//
//  LineAndPieVC.swift
//  ChartsJazz
//
//  Created by Daniel J Janiak on 8/23/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import Charts

class LineAndPieVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var pieChartView: PieChartView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create some sample data */
        let months =  ["Jan", "Feb", "Mar"] //["Jan", "Feb", "Mar", "Apr", "May", "Jun"] //[1.0, 3.0, 5.0, 10.0, 11.0, 12.0]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        //        if let maximumValue = unitsSold.maxElement() {
        //            let topLinePlotFillValue = maximumValue
        //        }
        
        let dataForSecondLine = [0.0, 0.0, 20.0, 20.0, 20.0, 20.0]
        
        let dataToPlot = [unitsSold, dataForSecondLine, unitsSold]
        
        //setChart(months, values: unitsSold)
        setCharts(months, dataCollections: dataToPlot)
    }
    
    // MARK: - Helpers
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet) // plot one line
        
        /* Caution: Experimental  ------------------- */
        
        // lineChartData.
        
        // LineChartRenderer
        
        // lineChartDataSet.
        
        // Shade the area under the curve = documentation's "line surface area"
        lineChartDataSet.fillColor = UIColor.redColor() // COLOR FOR AREA UNDER THE CURVE
        lineChartDataSet.drawFilledEnabled = true // AREA UNDER THE CURVE
        
        lineChartDataSet.mode = .CubicBezier // mode by which to join the points
        
        lineChartDataSet.cubicIntensity = 0.25 // min 0.05 (looks linear), max = 1
        
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = true  //?
        if (lineChartDataSet.isVerticalHighlightIndicatorEnabled) {
            print("The vertical highlight indicator is enabled")
        }
        
        
        lineChartDataSet.setColor(UIColor.blueColor()) // Change the color of the entire line
        
        // super ugly, but it's clear what does what
        lineChartDataSet.drawCirclesEnabled = true
        lineChartDataSet.circleHoleColor = UIColor.greenColor()
        lineChartDataSet.circleColors = [UIColor.brownColor()]
        
        /* ------------------------------------ */
        
        lineChartView.data = lineChartData
        
        /* Customize the look of the line chart */
        // lineChartView.backgroundColor =  UIColor.blueColor()
        //lineChartView
        
    }
    
    func setCharts(dataPoints: [String], dataCollections: [[Double]]) {
        //func setCharts(dataPoints: [Double], dataCollections: [[Double]]) {
        
        /* Create (potentially mutiple) arrays of data entries that will be used to create line chart and pie chart data set objects*/
        var completeDataEntriesCollection: [[ChartDataEntry]] = [[]]
        
        for item in dataCollections {
            
            var newDataCollection: [ChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: item[i], xIndex: i)
                newDataCollection.append(dataEntry)
            }
            
            completeDataEntriesCollection.append(newDataCollection)
            
        }
        
        completeDataEntriesCollection.removeFirst()
        
        /* Create and configure the Pie chart data */
        let pieChartDataSet = PieChartDataSet(yVals: completeDataEntriesCollection[0], label: "Units Sold")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        let color = ChartColorTemplates.joyful() // other: .liberty, .pastel, .colorful and .vordiplom
        pieChartDataSet.colors = color
        
        /* Create and configure the Line chart data */
        if completeDataEntriesCollection.count == 2 {
            let lineChartDataSet1 = LineChartDataSet(yVals: completeDataEntriesCollection[0], label: "Line 1")
            let lineChartDataSet2 = LineChartDataSet(yVals: completeDataEntriesCollection[1], label: "Line 2")
            
            /* Customize the appearance of the lines */
            lineChartDataSet1.setColor(UIColor.blueColor())
            lineChartDataSet1.fillColor = UIColor.blackColor()
            lineChartDataSet1.drawFilledEnabled = true
            // lineChartDataSet1.fillAlpha = 1.0
            
            lineChartDataSet2.setColor(UIColor.greenColor())
            lineChartDataSet2.fillColor = UIColor.whiteColor()
            lineChartDataSet2.drawFilledEnabled = true
            lineChartDataSet2.fillAlpha = 1.0
            //lineChartDataSet2.mode = .CubicBezier
            //lineChartDataSet2.cubicIntensity = 0.05
            lineChartDataSet2.mode = .Stepped
            
            let linesToPlot = [lineChartDataSet1, lineChartDataSet2]
            let lineChartData = LineChartData(xVals: dataPoints, dataSets: linesToPlot) // plot multiple lines
            lineChartView.data = lineChartData
            
        } else if completeDataEntriesCollection.count == 3 {
            
            lineChartView.xAxis.drawGridLinesEnabled = false
            lineChartView.drawGridBackgroundEnabled = false
            
            lineChartView.leftAxis.drawGridLinesEnabled = false
            //lineChartView.leftAxis.enabled = false
            lineChartView.leftAxis.axisMinValue = 0.0
            
            lineChartView.rightAxis.drawGridLinesEnabled = false
            lineChartView.rightAxis.enabled = false
            
            
            let linePlotBackgroundColor = UIColor.whiteColor()
            lineChartView.backgroundColor = linePlotBackgroundColor
            
            let lineChartDataSet1 = LineChartDataSet(yVals: completeDataEntriesCollection[0], label: "Line 1")
            let lineChartDataSet2 = LineChartDataSet(yVals: completeDataEntriesCollection[1], label: "Line 2")
            let lineChartDataSet3 = LineChartDataSet(yVals: completeDataEntriesCollection[2], label: "Line 3")
            
            let lineColor = UIColor.blueColor()
            
            /* Customize the appearance of line 1 */
            lineChartDataSet1.setColor(lineColor)
            lineChartDataSet1.fillColor = UIColor.redColor()
            lineChartDataSet1.drawFilledEnabled = true
            lineChartDataSet1.drawCirclesEnabled = true
            lineChartDataSet1.circleColors = ChartColorTemplates.liberty()
            
            /* Customize the appearance of line 2 */
            lineChartDataSet2.setColor(linePlotBackgroundColor)
            lineChartDataSet2.fillColor = linePlotBackgroundColor
            lineChartDataSet2.drawFilledEnabled = true
            lineChartDataSet2.fillAlpha = 1.0
            lineChartDataSet2.mode = .Stepped
            lineChartDataSet2.drawCirclesEnabled = false
            
            /* Customize the appearance of line 3 */
            lineChartDataSet3.setColor(lineColor)
            lineChartDataSet3.drawCirclesEnabled = false
            
            
            let linesToPlot = [lineChartDataSet1, lineChartDataSet2, lineChartDataSet3]
            let lineChartData = LineChartData(xVals: dataPoints, dataSets: linesToPlot) // plot multiple lines
            lineChartView.data = lineChartData
            
            /* Remove the legend */
            lineChartView.legend.enabled = false
            
            /* Remove the description */
            lineChartView.descriptionText = ""
            
            /* Add animation */
            lineChartView.animate(yAxisDuration: 1.5, easingOption: .EaseInOutQuart)
            
            /* Disable tap behavior (collapses data) */
            lineChartView.userInteractionEnabled = false
            
            /* Remove labels from the data points */
            lineChartView.data?.setValueTextColor(UIColor.clearColor())
        }
        
        
        
        
    }
    
    
}
