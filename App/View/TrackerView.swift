//
//  TrackerView.swift
//  App
//
//  Created by Eric on 6/3/22.
//

import Foundation
import SwiftUI
import Charts
import UIKit
import MobileCoreServices

let timescales = ["Last 24h", "Week", "Month", "Year"]

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
		for i in 0..<values.count{
			let tapstruct : timedtaps = values[i] ?? timedtaps()
			let date = UTCtolocal(date: Date(timeIntervalSince1970:tapstruct.timestamp/1000))
			let x = Double(date) ?? 0
			let y = Double(tapstruct.taps)
			// print(forX[i])
			// let dataEntry = BarChartDataEntry(x: (forX[i] as NSString).doubleValue, y: Double(unitsSold[i]))
			let dataEntry = BarChartDataEntry(x: x, y: y , data: hours as AnyObject?)
			dataEntries.append(dataEntry)
			print("x: \(x), y: \(y)")
		}
		print("_____________________")
		let chartDataSet = BarChartDataSet(entries: dataEntries, label: "taps")
		let chartData = BarChartData(dataSet: chartDataSet)
		chartData.barWidth = Double(100)
		chart.data = chartData
	}
}

struct TrackerView: View {
	@ObservedObject var api : API
	@State var selection = "Last 24h"
    var body: some View {
		VStack{
			HStack{
				Text("Scale:")
				Picker("Timescale", selection: $selection) {
					ForEach(timescales, id: \.self) {
						Text($0)
					}
				}
				.pickerStyle(.menu)
			}
			BarChart(API: api, scale: selection)
		}
	}
}

struct TrackerView_Previews: PreviewProvider {
	@StateObject static var capi = API()
    static var previews: some View {
		TrackerView(api: capi)
    }
}
