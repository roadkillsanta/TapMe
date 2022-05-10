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
			Rectangle().frame(width:.infinity, height: .infinity).foregroundColor(settings.bgColor)
			TabView(selection: $tabState) {
				SettingsView().environmentObject(settings).tabItem {
					Label("Settings", systemImage: "gear.circle")
				}.tag(0)
				PressButtonView(api: API, settings: settings).tabItem {
					Label("Button", systemImage: "play.circle")
				}.tag(1)
				UpgradeView().tabItem{
					Label("Upgrades", systemImage: "arrow.up.circle")
				}.tag(2)
			}
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
