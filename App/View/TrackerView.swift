//
//  TrackerView.swift
//  App
//
//  Created by Eric on 6/3/22.
//

import Foundation
import SwiftUI
import MobileCoreServices

let timescales = ["Last 24h", "Week", "Month", "Year"]

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
			ZStack{
				Rectangle().foregroundColor(Color(UIColor.white))
				let year = Calendar.current.component(.year, from: Date())
				VStack{
					Text("Stats at a glance:")
					HStack(){
						Text("Today:")
						Spacer()
						Text("")
					}
					HStack(){
						Text("This Week:")
						Spacer()
						Text("")
					}
					HStack(){
						Text("This Month:")
						Spacer()
						Text("")
					}
					HStack(){
						Text("\(String(year)):")
						Spacer()
						Text("")
					}
				}.padding()
			}
		}
	}
}

struct TrackerView_Previews: PreviewProvider {
	@StateObject static var capi = API()
    static var previews: some View {
		TrackerView(api: capi)
    }
}
