//
//  BarChartView.swift
//  App
//
//  Created by Eric on 6/10/22.
//

import Foundation
import UIKit
import SwiftUI
import Charts

struct BarChart: UIViewRepresentable{
	typealias UIViewType = BarChartView
	var API : API
	var scale : String
	
	@State var barchart = BarChartView()
	
	func makeUIView(context: Context) -> BarChartView {
		configure(chart: barchart, scale: scale)
		return barchart
	}
	func updateUIView(_ uiView: BarChartView, context: Context){
		configure(chart: uiView, scale: scale)
	}
	func UTCtolocal(date : Date) -> String{
		let dateFormatter = DateFormatter()
		dateFormatter.timeZone = TimeZone.current
		dateFormatter.dateFormat = "HHmm"
	
		return dateFormatter.string(from: date)
	}
	func tfhourview(chart: BarChartView) -> [BarChartDataEntry]{//24 hour bar chart view
		var dataEntries:[BarChartDataEntry] = []
		let values = API.today
		var yesterday = false;
		for i in 0..<values.count{
			let tapstruct : timedtaps = values[i]
			let date = UTCtolocal(date: Date(timeIntervalSince1970: tapstruct.timestamp/1000))
			var x = Double(date) ?? 0
			let y = Double(tapstruct.taps)
			if(yesterday){
				x = x-2400
			}
			// print(forX[i])
			// let dataEntry = BarChartDataEntry(x: (forX[i] as NSString).doubleValue, y: Double(unitsSold[i]))
			let dataEntry = BarChartDataEntry(x: x, y: y)
			dataEntries.append(dataEntry)
			if(x == 0){
				yesterday = true;
			}
		}
		return dataEntries
	}
	func othertimeview(chart: BarChartView, timescale : String) -> [BarChartDataEntry]{//week bar chart view
		var dataEntries:[BarChartDataEntry] = []
		let values = API.getDetailedStats()[timescale.lowercased()] ?? [0]
		var yesterday = false;
		for i in 0..<(values.count){
			var x = Double(i+1)
			let y = Double(values[i])
			// print(forX[i])
			// let dataEntry = BarChartDataEntry(x: (forX[i] as NSString).doubleValue, y: Double(unitsSold[i]))
			let dataEntry = BarChartDataEntry(x: x, y: y)
			dataEntries.append(dataEntry)
			if(x == 0){
				yesterday = true;
			}
		}
		return dataEntries
	}
	func configure(chart: BarChartView, scale : String){
		chart.noDataText = "Data Unavailable"
		var dataEntries:[BarChartDataEntry] = []
		var barWidth = Double(1)
		if(scale == "Last 24h"){
			dataEntries = tfhourview(chart: chart)
			barWidth = Double(100)
		}
		else{
			dataEntries = othertimeview(chart: chart, timescale: scale)
			barWidth = Double(1)
		}
		let chartDataSet = BarChartDataSet(entries: dataEntries, label: "taps")
		let chartData = BarChartData(dataSet: chartDataSet)
		chartData.barWidth = barWidth
		chart.data = chartData
	}
}
