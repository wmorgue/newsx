//
//  EmptyImageView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/10/21.
//

import SwiftUI

struct EmptyImageView: View {
	var body: some View {
		HStack {
			Spacer()
			ProgressView()
			Spacer()
		}
	}
}

struct EmptyImageView_Previews: PreviewProvider {
	static var previews: some View {
		EmptyImageView()
	}
}
