//
//  EmptyPlaceholderVIew.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/15/21.
//

import SwiftUI


/// Display text and image when view doesn't have any data
struct EmptyPlaceholderView: View {
	
	/// Text string to display
	let text: String
	
	/// Image to display
	let image: () -> Image?
	
	/// Create a view that's display text and image
	/// - Parameters:
	///   - text: The text which be display
	///   - image: The image which be display
	internal init(text: String, image: @escaping () -> Image?) {
		self.text = text
		self.image = image
	}

	
	var body: some View {
		VStack(spacing: 8) {
			Spacer()
			if let image = image {
				image()
					.imageScale(.large)
					.font(.system(size: 52))
			}
			Text(text)
			Spacer()
		}
	}
}


struct EmptyPlaceholderView_Previews: PreviewProvider {
	static var previews: some View {
		EmptyPlaceholderView(text: "No Bookmarks") {
			Image(systemName: "bookmark")
		}
		.previewDisplayName("Empty Placeholder")
	}
}
