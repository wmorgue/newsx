//
//  RetryView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/15/21.
//

import SwiftUI


/// A view that shows when articles can't load success
struct RetryView: View {
	/// Text to dispay
	let text: String
	/// Async closure action
	let retryAction: () async -> Void
	
	var body: some View {
		VStack(spacing: 8) {
			Text(text)
				.font(.callout)
				.padding(.vertical)
				.multilineTextAlignment(.center)
			
			retryButton
		}
	}
}

extension RetryView {
	private var retryButton: some View {
		Button {
			Task {
				await retryAction()
			}
		} label: {
			Text("Try again")
		}
		.buttonStyle(.bordered)
	}
}

struct RetryView_Previews: PreviewProvider {
	static var previews: some View {
		RetryView(text: "An error ocurred") {}
		.previewDisplayName("Retry")
	}
}
