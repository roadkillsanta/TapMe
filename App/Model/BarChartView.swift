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
	func configure(chart: BarChartView, scale : String){
		chart.noDataText = "Data Unavailable"
		var dataEntries:[BarChartDataEntry] = []
		var values = API.today
		var hours : [String] = [""]
		var yesterday = false;
		for i in 0..<values.count{
			let tapstruct : timedtaps = values[i] ?? timedtaps()
			let date = UTCtolocal(date: Date(timeIntervalSince1970: tapstruct.timestamp/1000))
			var x = Double(date) ?? 0
			let y = Double(tapstruct.taps)
			if(yesterday){
				x = x-2400
			}
			// print(forX[i])
			// let dataEntry = BarChartDataEntry(x: (forX[i] as NSString).doubleValue, y: Double(unitsSold[i]))
			let dataEntry = BarChartDataEntry(x: x, y: y , data: hours as AnyObject?)
			dataEntries.append(dataEntry)
			print("x: \(x), y: \(y)")
			if(x == 0){
				yesterday = true;
			}
		}
		print("_____________________")
		let chartDataSet = BarChartDataSet(entries: dataEntries, label: "taps")
		let chartData = BarChartData(dataSet: chartDataSet)
		chartData.barWidth = Double(100)
		chart.data = chartData
	}
	func dataFromTimescale(timescale : String){
		/*if(timescale == "Last 24h"){
			
		}*/
		if(timescale == "Week"){
			
		}
		else if(timescale == "Month"){
			
		}
		else if(timescale == "Year"){
			
		}
	}
}
