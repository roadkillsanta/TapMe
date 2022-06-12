//
//  ContentView.swift
//  App
//
//  Created by Me on 5/8/22.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var API : API
	@ObservedObject var settings : Settings
	@State var tabState = 1
	@State var scale : CGFloat = 0.8
    var body: some View {
		ZStack{
			Rectangle().foregroundColor(settings.bgColor)
			TabView(selection: $tabState) {
				SettingsView(settings: settings, api: API).tabItem {
					Label("Settings", systemImage: "gear")
				}.tag(0)
				SelectFidgetView(api: API, settings: settings).tabItem {
					Label("Fidget", systemImage: "play.circle")
				}.tag(1)
				TrackerView(api: API).tabItem{
					Label("Tracker", systemImage: "chart.bar")
				}.tag(2)
			}.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	@StateObject static var capi = API()
	@StateObject static var settings = Settings()
    static var previews: some View {
		ContentView(API: capi, settings: settings)
    }
}
