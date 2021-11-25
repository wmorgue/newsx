//
//  FailureImageView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/10/21.
//

import SwiftUI


/// Image and text that's showing when image can't loading
struct FailureImageView: View {
	
	/// Text to display
	let text: String = "Can't load the image."
	/// System image name
	let imageName: String = "photo.on.rectangle"
	
	var body: some View {
		HStack {
			Spacer()
			VStack(spacing: 25) {
				Image(systemName: imageName)
					.font(.title)
					.imageScale(.large)
				Text(text)
					.foregroundColor(.gray)
			}
			Spacer()
		}
	}
}

struct FailureImageView_Previews: PreviewProvider {
	static var previews: some View {
		FailureImageView()
			.previewDisplayName("Failure Image")
	}
}
