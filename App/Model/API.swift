//
//  API.swift
//  App
//
//  Created by Eric on 5/8/22.
//

import Foundation
import SwiftUI

struct Response: Decodable{
	var global : UInt64
	var local : UInt64
}


class API: ObservableObject{
	@Published var presses : UInt64
	@Published var globalpresses : UInt64
	var deviceID = UIDevice.current.identifierForVendor!.uuidString
	init(){
		self.presses = 0
		self.globalpresses = 0
		readpresses(completion: {response in
			self.presses = response.local
			self.globalpresses = response.global
		})
		let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateGlobal), userInfo: nil, repeats: true)
	}
	func readpresses(completion: @escaping (Response) -> ()){
		guard let url = URL(string: "https://Press-Me-API.roadkillsanta.repl.co/api/\(deviceID)") else {return}

		URLSession.shared.dataTask(with: url) { (data, response, errors) in
			guard let data = data else {return}
			
			let decoder = JSONDecoder()
			if let response = try? decoder.decode(Response.self, from: data){
				DispatchQueue.main.async {
					completion(response)
				}
			}
		}.resume()
	}
	func writepresses(completion: @escaping (UInt64) -> ()) {
		guard let url = URL(string: "https://Press-Me-API.roadkillsanta.repl.co/api/\(deviceID)/setpresses/\(presses)") else {return}

		URLSession.shared.dataTask(with: url) { (data, response, errors) in
			guard let data = data else {return}
			
			let decoder = JSONDecoder()

			if let response = try? decoder.decode(Response.self, from: data){
				DispatchQueue.main.async {
					completion(response.global)
				}
			}
		}.resume()
	}
	@objc func updateGlobal(){
		readpresses(completion: {response in
			self.globalpresses = response.global
		})
	}
	func press(){
		self.presses += 1
		writepresses(completion: {global in
			self.globalpresses = global
		})
	}
}
