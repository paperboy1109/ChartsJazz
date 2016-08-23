//
//  BarChartVC.swift
//  ChartsJazz
//
//  Created by Daniel J Janiak on 8/23/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import Charts

class BarChartVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var barChartView: BarChartView!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sales = DataGenerator.data()
        var salesEntries = [ChartDataEntry]()
        var salesMonths = [String]()
        
        /* Prepare the sample data to be displayed in the bar chart */
        var i = 0
        for sale in sales {
            // Create single chart data entry and append it to the array
            let saleEntry = BarChartDataEntry(value: sale.value, xIndex: i)
            salesEntries.append(saleEntry)
            
            // Append the month to the array
            salesMonths.append(sale.month)
            
            i += 1
        }
        
        let chartDataSet = BarChartDataSet(yVals: salesEntries, label: "Profit")
        let chartData = BarChartData(xVals: salesMonths, dataSets: [chartDataSet])
        barChartView.data = chartData
        
        addCustomizationToBarChart(chartDataSet)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Helpers
    func addCustomizationToBarChart(data: BarChartDataSet) {
        
        barChartView.descriptionText = "What a cool chart!"
        
        /* Add some labeling */
        barChartView.xAxis.labelPosition = .Bottom
        
        /* Don't skip an labels */
        barChartView.xAxis.setLabelsToSkip(0)
        
        /* Scale the chart */
        barChartView.leftAxis.axisMinValue = 0.0
        barChartView.leftAxis.axisMaxValue = 1000.0
        
        /* Add color */
        data.colors = ChartColorTemplates.joyful() // other: .liberty, .pastel, .colorful and .vordiplom
        
        /* Remove the legend */
        barChartView.legend.enabled = false
        
        /* Disable zooming */
        barChartView.scaleYEnabled = false
        barChartView.scaleXEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        
        /* Disable the ability to tap a bar in the chart */
        barChartView.highlighter = nil
        
        /* Remove the right axis and gridlines */
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        /* Add animation */
        barChartView.animate(yAxisDuration: 1.5, easingOption: .EaseInOutQuart)
        
        
        
    }
    
}
