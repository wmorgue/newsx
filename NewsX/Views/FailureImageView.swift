//
//  FailureImageView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/10/21.
//

import SwiftUI

struct FailureImageView: View {
	var body: some View {
		HStack {
			Spacer()
			VStack(spacing: 25) {
				Image(systemName: "photo.on.rectangle")
					.font(.title)
					.imageScale(.large)
				Text("Can't load the image.")
					.foregroundColor(.gray)
			}
			Spacer()
		}
	}
}

struct FailureImageView_Previews: PreviewProvider {
	static var previews: some View {
		FailureImageView()
	}
}
