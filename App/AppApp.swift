//
//  AppApp.swift
//  App
//
//  Created by Me on 5/8/22.
//

import SwiftUI

@main
struct AppApp: App {
	@StateObject var api = API()
	@StateObject var settings = Settings()
    var body: some Scene {
        WindowGroup {
			ContentView(API: api, settings: settings)
        }
    }
}
