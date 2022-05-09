//
//  ContentView.swift
//  App
//
//  Created by Eric on 5/8/22.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var API : API
    var body: some View {
		PressButtonView(initapi: API)
    }
}

struct ContentView_Previews: PreviewProvider {
	@StateObject static var capi = API()
    static var previews: some View {
		ContentView(API: capi)
    }
}
