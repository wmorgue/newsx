//
//  TabContentView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/22/21.
//

import SwiftUI

struct TabContentView: View {
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

struct TabContentView_Previews: PreviewProvider {
	static var previews: some View {
		TabContentView()
	}
}
