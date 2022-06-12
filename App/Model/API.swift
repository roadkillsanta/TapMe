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
	var registered : Bool
	var received : Int
}

class API: ObservableObject{
	@Published var presses : UInt64
	@Published var globalpresses : UInt64
	@Published var history : [String : [String : [String : Int]]]
	@Published var today : [timedtaps]
	@Published var saveData : Bool
	@Published var offline : Bool
	@Published var registered : Bool
	@Published var syncInterval : Double
	@Published var noTrack : Bool
	@Published var hapticSetting : String
	var pressesSinceLastSync : Int
	var deviceID = UIDevice.current.identifierForVendor!.uuidString
	init(){
		self.presses = 0
		self.globalpresses = 0
		self.history = [:]
		self.today = []
		self.saveData = false
		self.offline = false
		self.registered = false
		self.syncInterval = 2.5
		self.pressesSinceLastSync = 0
		self.noTrack = false
		self.hapticSetting = "Light"
		readpresses(completion: {response in
			self.presses = response.local
			self.globalpresses = response.global
			self.history = response.history.data
			self.today = response.history.last
			self.registered = response.registered
		})
		let timer = Timer.scheduledTimer(timeInterval: syncInterval, target: self, selector: #selector(self.updateGlobal), userInfo: nil, repeats: true)
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
	func sync(completion: @escaping (Response) -> ()){
		let url = URL(string: "https://api.pgang.org/user/\(deviceID)")!
		var request = URLRequest(url: url)
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.httpMethod = "POST"
		do{
		let jsonEncoder = JSONEncoder()
		let jsonData = try jsonEncoder.encode(history)
		let content = String(data: jsonData, encoding: String.Encoding.utf8)
		let parameters: [String: Any] = [
			"sync" : true,
			"presses" : self.pressesSinceLastSync,
			"time" : Date.init()
			//"history" : content ?? ""
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
				completion(responseObject)
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
		catch{
			print("failed serialization")
		}
	}
	@objc func updateGlobal(){
		if(!noTrack){
			self.sync(completion: {response in
				DispatchQueue.main.async{
					self.globalpresses = response.global
					self.history = response.history.data
					self.today = response.history.last
					self.pressesSinceLastSync -= response.received
				}
			})
		}
	}
	func press(){
		if(hapticSetting != "None"){
			Haptic.impact(HapticFeedbackStyle(rawValue: hapticStyle[hapticSetting] ?? 0) ?? .light).generate()
		}
		if(!noTrack){
			self.presses += 1
			self.globalpresses += 1
			self.pressesSinceLastSync += 1
		}
	}
	@IBAction func notify() {
		NotificationCenter.default.post(name: Notification.Name(rawValue: "API updated!"), object: self)
	}
	func getDetailedStats() -> [String: [Int]]{
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = TimeZone(identifier: "UTC")!
		let cday = calendar.component(.day, from: Date())
		let daynum = calendar.dateComponents([.weekday], from: Date()).weekday ?? 0
		var day = [0]
		var week = [0, 0, 0, 0, 0, 0, 0]
		var month = [Int](repeating: 0, count: calendar.range(of: .day, in: .month, for: Date())?.count ?? 0)
		var year = [Int](repeating: 0, count: 12)
		for (key, value) in history{//years
			let cyear = Int(key) ?? 0
			for(key, value) in value{//months
				let cmonth = Int(key) ?? 0
				for (key, value) in value{//days
					guard let keyvalue = Int(key) else{
						print("no")
						continue
					}
					if(cmonth == calendar.component(.month, from: Date())-1 && cyear == calendar.component(.year, from: Date())){//if the current month in the loop is equal to the current month in real-time
						if(keyvalue <= cday+7-daynum && keyvalue > cday-daynum){//if the day is in this week
							if(keyvalue == cday){//if it's today
								day[0] = value
							}
							week[keyvalue-cday+daynum-1] = value
						}
						month[keyvalue-1] = value //if the int resolves to nil, it becomes 0. assign this junk value to the 0 slot (it will go unused)
					}
					year[cmonth] = year[cmonth]+value //this works because the month stored serverside begins at 0.
				}
			}
		}
		return ["day": day, "week" : week, "month" : month, "year" : year];
	}
	func getStats() -> [String:Int]{
		let data = getDetailedStats()
		var returndata : [String: Int] = [:]
		returndata["day"] = data["day"]?.reduce(0, +)
		returndata["week"] = data["week"]?.reduce(0, +)
		returndata["month"] = data["month"]?.reduce(0, +)
		returndata["year"] = data["year"]?.reduce(0, +)
		return returndata;
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
