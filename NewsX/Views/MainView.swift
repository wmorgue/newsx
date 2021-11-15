//
//  MainView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/15/21.
//

import SwiftUI

struct MainView: View {
	var body: some View {
		TabView {
			NewsTabView()
				.tabItem {
					Label("News", systemImage: "newspaper")
				}
		}
	}
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
			.previewDisplayName("Main screen")
	}
}
