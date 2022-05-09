//
//  AppApp.swift
//  App
//
//  Created by Eric on 5/8/22.
//

import SwiftUI

@main
struct AppApp: App {
	@StateObject var api = API()
    var body: some Scene {
        WindowGroup {
			ContentView(API: api)
        }
    }
}
