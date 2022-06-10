//
//  API.swift
//  App
//
//  Created by Me on 5/8/22.
//

import Foundation
import SwiftUI
import Haptica

struct timedtaps: Decodable{
	var timestamp: Double
	var taps: Int
	init(){
		self.taps = 0
		self.timestamp = 0
	}
}

struct history : Decodable{
	var data : [String : [String : [String : Int]]]
	var last : [timedtaps]
}

struct Response: Decodable{
	var global : UInt64
	var local : UInt64
	var history : history
}

class API: ObservableObject{
	@Published var presses : UInt64
	@Published var globalpresses : UInt64
	@Published var history : [String : [String : [String : Int]]]
	@Published var today : [timedtaps]
	var deviceID = UIDevice.current.identifierForVendor!.uuidString
	init(){
		self.presses = 0
		self.globalpresses = 0
		self.history = [:]
		self.today = []
		readpresses(completion: {response in
			self.presses = response.local
			self.globalpresses = response.global
			self.history = response.history.data
			self.today = response.history.last
		})
		let timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.updateGlobal), userInfo: nil, repeats: true)
	}
	func readpresses(completion: @escaping (Response) -> ()){
		guard let url = URL(string: "https://api.pgang.org/user/\(deviceID)") else {return}

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
		let url = URL(string: "https://api.pgang.org/user/\(deviceID)")!
		var request = URLRequest(url: url)
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.httpMethod = "POST"
		let parameters: [String: Any] = [
			"presses": self.presses,
			"time": Date.init()
		]
		request.httpBody = parameters.percentEncoded()

		URLSession.shared.dataTask(with: request) { data, response, error in
			guard
				let data = data,
				let response = response as? HTTPURLResponse,
				error == nil
			else {                                                               // check for fundamental networking error
				print("error", error ?? URLError(.badServerResponse))
				return
			}
			
			guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
				print("statusCode should be 2xx, but is \(response.statusCode)")
				print("response = \(response)")
				return
			}
			
			// do whatever you want with the `data`, e.g.:
			do {
				let responseObject = try JSONDecoder().decode(Response.self, from: data)
				completion(responseObject.global)
			} catch {
				print(error) // parsing error
				
				if let responseString = String(data: data, encoding: .utf8) {
					print("responseString = \(responseString)")
				} else {
					print("unable to parse response as string")
				}
			}
		}.resume()
	}
	@objc func updateGlobal(){
		readpresses(completion: {response in
			self.globalpresses = response.global
			self.history = response.history.data
			self.today = response.history.last
		})
	}
	func press(){
		self.presses += 1
		writepresses(completion: {global in
			self.globalpresses = global
		})
	}
	@IBAction func notify() {
		NotificationCenter.default.post(name: Notification.Name(rawValue: "API updated!"), object: self)
	}
	func getStats(){
		var returndata : [String:Int] = [:]
		let year = Calendar.current.component(.year, from: Date())
		let month = Calendar.current.component(.month, from: Date())
		let day = Calendar.current.component(.day, from: Date())
		var thismonth = false
		for (key, value) in history{
			for(key, value) in value{
				if(Int(key) +1 == month){
					thismonth = true
				}
				else{
					thismonth = false
				}
				for (key, value) in value{
					if(thismonth){
						returndata["month"] = returndata["month"] ?? 0 + value
					}
					returndata["year"] = returndata["year"] ?? 0 + value
				}
			}
		}
	}
}

class Settings: ObservableObject{
	@Published var bgColor : Color = Color(UIColor.white)
	@Published var btnColor : Color = Color(UIColor.systemCyan)
	@Published var txtColor : Color = Color(UIColor.white)
	@Published var displayColor : Color = Color(UIColor.gray)
	@State var scale : CGFloat = 0.8
	init(){
		
	}
	func reset(){
		self.bgColor = Color(UIColor.white)
		self.btnColor = Color(UIColor.systemCyan)
		self.txtColor = Color(UIColor.white)
		self.scale = 0.8
	}
}

extension Dictionary {
	func percentEncoded() -> Data? {
		map { key, value in
			let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
			return escapedKey + "=" + escapedValue
		}
		.joined(separator: "&")
		.data(using: .utf8)
	}
}

extension CharacterSet {
	static let urlQueryValueAllowed: CharacterSet = {
		let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
		let subDelimitersToEncode = "!$&'()*+,;="
		
		var allowed: CharacterSet = .urlQueryAllowed
		allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		return allowed
	}()
}
