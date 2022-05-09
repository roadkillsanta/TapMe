//
//  PressButtonView.swift
//  App
//
//  Created by Eric on 5/8/22.
//

import SwiftUI

struct PressButtonView: View{
	//@State var isPressed : Bool = false
	var scale : CGFloat
	@ObservedObject var api : API
	var currentOpacity = 0.5
	init(scale : CGFloat = 0.8, initapi: API){
		self.scale = scale
		self.api = initapi
	}
	var body : some View{
		VStack{
		Spacer()
		ZStack{
			RoundedRectangle(cornerRadius: 5).opacity(0.1)
				.frame(width: UIScreen.main.bounds.width * 1.1*scale, height: 240, alignment: Alignment.center)
			VStack{
				Text("All Presses")
				ZStack{
					RoundedRectangle(cornerRadius: 5)
						.opacity(0.5)
						.frame(width: UIScreen.main.bounds.width * scale, height: 64)
					Text("\(api.globalpresses)")
						.foregroundColor(Color(UIColor.white))
				}
				Text("Your Presses")
				ZStack{
					RoundedRectangle(cornerRadius: 5)
						.opacity(0.5)
						.frame(width: UIScreen.main.bounds.width * scale, height: 64)
					Text("\(api.presses)")
						.foregroundColor(Color(UIColor.white))
				}
			}
		}.padding(EdgeInsets(top: 80, leading: 0, bottom: 0, trailing: 0))
		ZStack{
			Circle()
				.frame(width: UIScreen.main.bounds.width * scale, height: UIScreen.main.bounds.width  * scale, alignment: Alignment.center)
				.padding(EdgeInsets(top: 0, leading: UIScreen.main.bounds.width * (1-scale)/2, bottom: 0, trailing: UIScreen.main.bounds.width * (1-scale)/2))
				.foregroundColor(Color(UIColor.systemCyan))
				.opacity(0.2)
			Button(action: api.press){
				ZStack(){
					Circle()
						.frame(width: UIScreen.main.bounds.width * (scale-0.1), height: UIScreen.main.bounds.width  * scale, alignment: Alignment.center)
						.foregroundColor(Color(UIColor.systemCyan))
						.opacity(0.5)
				}
			}
			Text("Press Me!").foregroundColor(Color(UIColor.white))
		}.padding(EdgeInsets(top: 16, leading: 0, bottom: 128, trailing: 0))
		}
	}
}

struct PressButtonView_Previews: PreviewProvider {
	@StateObject static var capi = API()
    static var previews: some View {
		PressButtonView(initapi: capi)
    }
}
