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
				.tabItem { Label("News", systemImage: "newspaper") }
			SearchTabView()
				.tabItem { Label("Search", systemImage: "doc.text.magnifyingglass") }
			BookmarkTabView()
				.tabItem { Label("Saved", systemImage: "bookmark.square") }
		}
	}
}

struct MainView_Previews: PreviewProvider {
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
	
	static var previews: some View {
		MainView()
			.environmentObject(articleBookmarkVM)
			.previewDisplayName("Main screen")
	}
}
