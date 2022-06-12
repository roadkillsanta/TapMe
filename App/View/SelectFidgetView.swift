//
//  SelectFidgetView.swift
//  App
//
//  Created by Eric on 6/11/22.
//

import SwiftUI

struct SelectFidgetView: View {
	@ObservedObject var api : API
	@ObservedObject var settings : Settings
	@State var tabState = 0
	@State var collapseStats = false
    var body: some View {
		VStack{
			if(collapseStats){
				ZStack(alignment: .topLeading){
					ZStack{
						RoundedRectangle(cornerRadius: 5)
							.opacity(0.2)
							.foregroundColor(settings.displayColor)
							.frame(width: UIScreen.main.bounds.width * 1.1*settings.scale, height: 40, alignment: Alignment.center)
						HStack{
							Text("All:")
							ZStack{
								RoundedRectangle(cornerRadius: 5)
									.opacity(1)
									.foregroundColor(settings.displayColor)
									.frame(width: UIScreen.main.bounds.width * settings.scale/4, height: 32)
								Text("\(api.globalpresses)")
									.foregroundColor(settings.txtColor)
							}
							Text("You:")
							ZStack{
								RoundedRectangle(cornerRadius: 5)
									.opacity(1)
									.foregroundColor(settings.displayColor)
									.frame(width: UIScreen.main.bounds.width * settings.scale/4, height: 32)
								Text("\(api.presses)")
									.foregroundColor(settings.txtColor)
							}
						}
					}
					Button(action: {collapseStats = !collapseStats}){
						Label("", systemImage: "arrow.down")
					}.padding(EdgeInsets(top: 10, leading: 12, bottom: 0, trailing: 0))
				}.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
			}else{
				ZStack(alignment: .topLeading){
					ZStack{
						RoundedRectangle(cornerRadius: 5)
							.opacity(0.2)
							.foregroundColor(settings.displayColor)
							.frame(width: UIScreen.main.bounds.width * 1.1*settings.scale, height: 200, alignment: Alignment.center)
						VStack{
							Text("All Fidgets")
							ZStack{
								RoundedRectangle(cornerRadius: 5)
									.opacity(1)
									.foregroundColor(settings.displayColor)
									.frame(width: UIScreen.main.bounds.width * settings.scale, height: 50)
								Text("\(api.globalpresses)")
									.foregroundColor(settings.txtColor)
							}
							Text("Your Fidgets")
							ZStack{
								RoundedRectangle(cornerRadius: 5)
									.opacity(1)
									.foregroundColor(settings.displayColor)
									.frame(width: UIScreen.main.bounds.width * settings.scale, height: 50)
								Text("\(api.presses)")
									.foregroundColor(settings.txtColor)
							}
						}
					}
					Button(action: {collapseStats = !collapseStats}){
						Label("", systemImage: "arrow.up")
					}.padding(EdgeInsets(top: 10, leading: 12, bottom: 0, trailing: 0))
				}.padding(EdgeInsets(top: 0.02*UIScreen.main.bounds.height, leading: 0, bottom: 0, trailing: 0))
			}
			TabView(selection: $tabState) {
				PressButtonView(api: api, settings: settings).tabItem {
					Text("Button")
				}.tag(0)
				FidgetSwitchView(api: api, settings: settings, collapsed: $collapseStats).tabItem{
					Text("Switches")
				}.tag(1)
			}.padding()
		}
    }
}

struct SelectFidgetView_Previews: PreviewProvider {
	@StateObject static var api = API()
	@StateObject static var settings = Settings()
    static var previews: some View {
		SelectFidgetView(api: api, settings: settings)
    }
}
