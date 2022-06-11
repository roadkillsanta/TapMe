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
		VStack(alignment: .leading, spacing: 0){
			ZStack{
				//Rectangle().foregroundColor(Color(UIColor.white))
				let year = Calendar.current.component(.year, from: Date())
				let stats = api.getStats()
				VStack{
					Text("Stats at a glance:")
					HStack(){
						Text("Today:")
						Spacer()
						Text("\(stats["day"] ?? 0)")
					}
					HStack(){
						Text("This Week:")
						Spacer()
						Text("\(stats["week"] ?? 0)")
					}
					HStack(){
						Text("This Month:")
						Spacer()
						Text("\(stats["month"] ?? 0)")
					}
					HStack(){
						Text("\(String(year)):")
						Spacer()
						Text("\(stats["year"] ?? 0)")
					}
				}.padding()
			}
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
			Spacer()
		}
	}
}

struct TrackerView_Previews: PreviewProvider {
	@StateObject static var capi = API()
    static var previews: some View {
		TrackerView(api: capi)
    }
}
