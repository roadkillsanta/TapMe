//
//  SettingsView.swift
//  App
//
//  Created by Me on 5/8/22.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var settings : Settings
    var body: some View {
		VStack{
			Text("Settings").padding(EdgeInsets(top: 20, leading: 0, bottom: 40, trailing: 0))
			VStack(){
				ZStack{
					RoundedRectangle(cornerRadius: 12).foregroundColor(Color(UIColor.systemGray6))
					VStack{
						ColorPicker("Background Color", selection: $settings.bgColor)
						ColorPicker("Button Color", selection: $settings.btnColor)
						ColorPicker("Text Color", selection: $settings.txtColor)
						ColorPicker("Display Color", selection: $settings.displayColor)
						HStack{
							Text("Version ")
							Spacer()
							Text("1.0.0").foregroundColor(Color(UIColor.systemGray))
						}
					}.padding()
				}.frame(width: UIScreen.main.bounds.width * 1.1 * settings.scale, height: 120)
				Spacer()
				Button(action: settings.reset){
					ZStack{
						RoundedRectangle(cornerRadius: 12).foregroundColor(Color(UIColor.systemGray6))
						Text("Restore Defaults")
					}
				}.frame(width: UIScreen.main.bounds.width * 1.1 * settings.scale, height: 50)
				Spacer()
			}.frame(height: UIScreen.main.bounds.height * settings.scale)
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	@StateObject static var settings = Settings()
    static var previews: some View {
		SettingsView().environmentObject(settings)
    }
}
