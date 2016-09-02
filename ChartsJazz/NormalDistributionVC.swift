//
//  NormalDistributionVC.swift
//  ChartsJazz
//
//  Created by Daniel J Janiak on 9/1/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import Charts

class NormalDistributionVC: UIViewController {
    
    // MARK: - Properties
    let plotBackgroundColor = UIColor.whiteColor()
    let sequenceGenerator = SequenceGenerator()
    let defaultStartingPoint = -2.5
    let defaultEndingPoint = 2.5
    let defaultPointsPerLine = 99
    
    // MARK: - Outlets
    
    @IBOutlet var normalDistributionView: LineChartView!
    @IBOutlet var zScoreTextField: UITextField!    
    @IBOutlet var pValueLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Create some sample data */
        let xValues = [-3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0]
        
        // let yValues = [2.0, 4.0, 8.0, 12.0, 8.0, 4.0, 2.0]
        var yValues: [Double] = []
        
        for item in xValues {
            yValues.append(easyQuadratic(item))
        }
        
        let removeFillValues = [Double](count: xValues.count, repeatedValue:0.0) //[0.0, 0.0, 0.0, 0.0, 0.0]
        // var sprites = [SKSpriteNode?](count:64, repeatedValue: nil)
        let dataToPlot = [yValues, removeFillValues, yValues]
        
        /* Configure the plot view */
        
        /* Remove the grid */
        normalDistributionView.xAxis.drawGridLinesEnabled = false
        normalDistributionView.drawGridBackgroundEnabled = false
        normalDistributionView.backgroundColor = plotBackgroundColor
        
        /* Set up the axes */
        normalDistributionView.leftAxis.drawGridLinesEnabled = false
        normalDistributionView.leftAxis.enabled = false
        normalDistributionView.leftAxis.axisMinValue = 0.0
        
        normalDistributionView.rightAxis.drawGridLinesEnabled = false
        normalDistributionView.rightAxis.enabled = false
        normalDistributionView.rightAxis.axisMinValue = 0.0
        
        normalDistributionView.xAxis.setLabelsToSkip(0)
        
        /* Remove the legend */
        normalDistributionView.legend.enabled = false
        
        /* Remove the description */
        normalDistributionView.descriptionText = ""
        
        /* Disable tap behavior (collapses data) */
        normalDistributionView.userInteractionEnabled = false
        
        /* Add animation */
        normalDistributionView.animate(yAxisDuration: 1.5, easingOption: .EaseInOutQuart)
        
        /* Draw the normal distribution */
        pNormWithFill(xValues, dataCollections: dataToPlot, shadeLeftTail: true)
        
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
    
    func pNormWithFill(xValues: [Double], dataCollections: [[Double]], shadeLeftTail: Bool) {
        
        let xValuesAsStrings = xValues.map { String(format: "%.2f", $0) }
        
        let bezierIntensity:CGFloat = 0.1
        
        /* Create (potentially mutiple) arrays of data entries that will be used to create line chart and pie chart data set objects*/
        var completeDataEntriesCollection: [[ChartDataEntry]] = [[]]
        
        for item in dataCollections {
            
            var newDataCollection: [ChartDataEntry] = []
            
            for i in 0..<xValues.count {
                let dataEntry = ChartDataEntry(value: item[i], xIndex: i)
                newDataCollection.append(dataEntry)
            }
            
            completeDataEntriesCollection.append(newDataCollection)
            
        }
        
        completeDataEntriesCollection.removeFirst()
        
        let lineChartDataSet_Layer1 = LineChartDataSet(yVals: completeDataEntriesCollection[0], label: "Line 1")
        let lineChartDataSet_Layer2 = LineChartDataSet(yVals: completeDataEntriesCollection[1], label: "Line 2")
        // let lineChartDataSet_Layer3 = LineChartDataSet(yVals: completeDataEntriesCollection[2], label: "Line 3")
        let lineChartDataSet_Layer3 = LineChartDataSet(yVals: completeDataEntriesCollection[0], label: "Line 3")
        
        // let xValuesForPlot = xValues
        
        let lineColor = UIColor.blueColor()
        
        /* Customize the appearance of line 1 */
        lineChartDataSet_Layer1.setColor(lineColor)
        lineChartDataSet_Layer1.fillColor = UIColor.redColor()
        lineChartDataSet_Layer1.drawFilledEnabled = true
        lineChartDataSet_Layer1.drawCirclesEnabled = false
        lineChartDataSet_Layer1.mode = .CubicBezier
        lineChartDataSet_Layer1.cubicIntensity = bezierIntensity
        
        /* Customize the appearance of line 2 */
        lineChartDataSet_Layer2.setColor(plotBackgroundColor)
        lineChartDataSet_Layer2.fillColor = plotBackgroundColor
        lineChartDataSet_Layer2.drawFilledEnabled = true
        lineChartDataSet_Layer2.fillAlpha = 1.0
        lineChartDataSet_Layer2.mode = .Stepped
        lineChartDataSet_Layer2.drawCirclesEnabled = false
        
        /* Customize the appearance of line 3 */
        lineChartDataSet_Layer3.setColor(lineColor)
        lineChartDataSet_Layer3.drawCirclesEnabled = false
        lineChartDataSet_Layer3.mode = .CubicBezier
        lineChartDataSet_Layer3.cubicIntensity = bezierIntensity


        
        
        let linesToPlot = [lineChartDataSet_Layer1, lineChartDataSet_Layer2, lineChartDataSet_Layer3]
        
        let lineChartData = LineChartData(xVals: xValuesAsStrings, dataSets: linesToPlot)
        
        /* Set the data to be included in the plot */
        normalDistributionView.data = lineChartData
        
        /* Remove labels from the data points */
        normalDistributionView.data?.setValueTextColor(UIColor.clearColor())
        
        // normalDistributionView.xAxis.axisMinValue
        normalDistributionView.leftAxis.axisMinValue = dataCollections[0].minElement()!
        normalDistributionView.rightAxis.axisMinValue = dataCollections[0].minElement()!
    }
    
    func easyQuadratic(xValue: Double) -> Double {
        
        let yValue = pow(2, (-0.25) * xValue * xValue) //pow((xValue - 2.0), 2) + 1
        
        return yValue
    }
    
    func lineDataForMaskingFill(xValues: [Double], targetValue: Double, leftTail: Bool) -> [Double] {
        
        let errorArray = xValues[0...xValues.count/2].map() {abs(targetValue - $0)}
        
        let maskingValue = xValues.maxElement()!
        let availableTarget = xValues[errorArray.indexOf(errorArray.minElement()!)!]
        let maskingArray = xValues.map() { (yValue) -> Double in
            
            if leftTail {
                return yValue < availableTarget ? 0 : maskingValue
            } else {
                return yValue < availableTarget ? maskingValue : 0
            }
        }
        
        return maskingArray
    }
    
    // MARK: - Actions
    
    @IBAction func pValueTapped(sender: AnyObject) {
        
        normalDistributionView.data = nil
        normalDistributionView.setNeedsLayout()
        
        if let zScoreText = zScoreTextField.text {
            
            if let zScore = zScoreText.doubleValue {
                
                if abs(zScore) <= 2.5 {
                    print("A typical z-score was entered.  No need to adjust the range of the plot")
                    
                    pValueLabel.text = String( Double(arc4random()) / Double(UINT32_MAX) )
                    
                    let xValues = sequenceGenerator.createSequenceWithStartingPoint(defaultStartingPoint, end: defaultEndingPoint, numberOfSteps: defaultPointsPerLine)
                    let yValues = xValues.map() {easyQuadratic($0)}
                    
                    let plotVerticalLimit = yValues.maxElement()! * 1.25
                    
                    //let maskFillValues = yValues.map() { 0.0 * $0 } // set all to 0 for now (entire plot is filled)
                    let maskFillValues = lineDataForMaskingFill(xValues, targetValue: zScore, leftTail: true)
                    
                    pNormWithFill(xValues, dataCollections: [yValues, maskFillValues], shadeLeftTail: true)
                    
                    normalDistributionView.xAxis.setLabelsToSkip(10)
                    
                    normalDistributionView.leftAxis.axisMaxValue = plotVerticalLimit
                    normalDistributionView.rightAxis.axisMaxValue = plotVerticalLimit
                    
                    normalDistributionView.setNeedsLayout()
                    
                    normalDistributionView.animate(yAxisDuration: 1.5, easingOption: .EaseInOutQuart)
                    
                } else {
                    print("A fairly extreme zScore was entered, adjust the range of the plot")
                    pValueLabel.text = "SUPER MEGA REJECT NULL"
                }
                
            }
        }
        
        
        
        
        
    }
    
    
    
}

extension NormalDistributionVC {
    
    // MARK: - Set keyboard behavior
    
    // Close the keyboard by tapping outside
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Close the keyboard by using the button on the keyboard
    // (not relevant when working with the number pad)
    /*
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    } */
    
}