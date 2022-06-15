//
//  FidgetWheelView.swift
//  App
//
//  Created by Eric on 6/12/22.
//

import SwiftUI
import SwiftFortuneWheel

class WheelView : UIViewControllerRepresentable{
	typealias UIViewControllerType = SFWViewController
	func makeUIViewController(context: Context) -> UIViewControllerType {
		let vc = SFWViewController()
		return vc
	}
	func updateUIViewController(_ uiViewController: SFWViewController, context: Context) {
		
	}
}

class SFWViewController: UIViewController {
	@IBOutlet weak var fortuneWheel: SwiftFortuneWheel!
	 override func viewDidLoad() {
		super.viewDidLoad()
		fortuneWheel.configuration = .defaultConfiguration
	}
}

extension SFWConfiguration {
	static var defaultConfiguration: SFWConfiguration {
		let sliceColorType = SFWConfiguration.ColorType.evenOddColors(evenColor: .black, oddColor: .cyan)

		let slicePreferences = SFWConfiguration.SlicePreferences(backgroundColorType: sliceColorType, strokeWidth: 1, strokeColor: .black)

		let circlePreferences = SFWConfiguration.CirclePreferences(strokeWidth: 10, strokeColor: .black)

		let wheelPreferences = SFWConfiguration.WheelPreferences(circlePreferences: circlePreferences, slicePreferences: slicePreferences, startPosition: .bottom)

		let configuration = SFWConfiguration(wheelPreferences: wheelPreferences)

		return configuration
	}
}

struct FidgetWheelView: View {
    var body: some View {
		WheelView()
    }
}

struct FidgetWheelView_Previews: PreviewProvider {
    static var previews: some View {
        FidgetWheelView()
    }
}
