//
//  RetryView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/15/21.
//

import SwiftUI

// TODO: Add documentation
struct RetryView: View {
	let text: String
	let retryAction: () async -> Void
	
	var body: some View {
		VStack(spacing: 8) {
			Text(text)
				.font(.callout)
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
