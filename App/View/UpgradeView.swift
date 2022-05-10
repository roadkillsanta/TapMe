//
//  UpgradeView.swift
//  App
//
//  Created by Eric on 5/10/22.
//

import SwiftUI

struct UpgradeView: View {
    var body: some View {
		VStack{
			Image(systemName: "hammer")
				.resizable()
				.scaledToFit()
				.frame(width: 150, height: 150, alignment: Alignment.center)
			Text("Coming Soon!").padding()
		}
    }
}

struct UpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeView()
    }
}
