//
//  PressButtonView.swift
//  App
//
//  Created by Me on 5/8/22.
//

import SwiftUI
import Haptica

struct PressButtonView: View{
	//@State var isPressed : Bool = false
	@ObservedObject var api : API
	@ObservedObject var settings : Settings
	var currentOpacity = 0.5
	var body : some View{
		ZStack{
			Circle()
				.frame(width: UIScreen.main.bounds.width * settings.scale, height: UIScreen.main.bounds.width  * settings.scale, alignment: Alignment.center)
				.padding(EdgeInsets(top: 0, leading: UIScreen.main.bounds.width * (1-settings.scale)/2, bottom: 0, trailing: UIScreen.main.bounds.width * (1-settings.scale)/2))
				.foregroundColor(settings.btnColor)
				.opacity(0.2)
			Button(action: api.press){
				ZStack(){
					Circle()
						.frame(width: UIScreen.main.bounds.width * (settings.scale-0.1), height: UIScreen.main.bounds.width * settings.scale, alignment: Alignment.center)
						.foregroundColor(settings.btnColor)
						.opacity(0.5)
				}
			}
			Text("Tap Me!").foregroundColor(settings.txtColor)
		}.padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
	}
}

struct PressButtonView_Previews: PreviewProvider {
	@StateObject static var capi = API()
	@StateObject static var settings = Settings()
    static var previews: some View {
		PressButtonView(api: capi, settings: settings)
    }
}
