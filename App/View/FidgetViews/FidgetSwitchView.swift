//
//  FidgetSwitchView.swift
//  App
//
//  Created by Eric on 6/11/22.
//

import SwiftUI

struct FidgetSwitchView: View {
	@ObservedObject var api : API
	@ObservedObject var settings : Settings
	@Binding var collapsed : Bool
	@State var elements = Int(round(UIScreen.main.bounds.width/60));
	@State var toggleBindings = [Bool](repeating: false, count: 256)
    var body: some View {
		VStack(alignment: .leading){
			let rows = Int(round(collapsed ? UIScreen.main.bounds.height/54 : UIScreen.main.bounds.height/80));
			ForEach((0...rows-1), id: \.self) {
				let cRow = $0;
				HStack{
					ForEach((0...elements-1), id: \.self){
						let elem = $0
						Toggle("", isOn: Binding(
							get: {toggleBindings[cRow*elements+elem]},
							set: {value in
							toggleBindings[cRow*elements+elem] = value
							api.press()
						})).labelsHidden()
					}
				}
			}
		}.padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
	}
}

struct FidgetSwitchView_Previews: PreviewProvider {
	@StateObject static var capi = API()
	@StateObject static var settings = Settings()
	@State static var collapsed = false
    static var previews: some View {
		FidgetSwitchView(api: capi, settings: settings, collapsed: $collapsed)
    }
}
