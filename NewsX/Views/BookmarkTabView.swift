//
//  BookmarkTabView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/16/21.
//

import SwiftUI

struct BookmarkTabView: View {
	@EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
	
	var body: some View {
		NavigationView {
			ArticleListView(articles: articleBookmarkVM.bookmarks)
				.overlay(bookmarkOverlay(isEmpty: articleBookmarkVM.bookmarks.isEmpty))
				.navigationTitle("Saved articles")
		}
	}
}

extension BookmarkTabView {
	@ViewBuilder
	private func bookmarkOverlay(isEmpty: Bool) -> some View {
		if isEmpty {
			EmptyPlaceholderView(text: "No saved bookmarks") {
				Image(systemName: "bookmark.slash")
			}
			.navigationBarHidden(true)
		}
	}
}

struct BookmarkTabView_Previews: PreviewProvider {
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel()
	
	static var previews: some View {
		BookmarkTabView()
			.environmentObject(articleBookmarkVM)
			.previewDisplayName("Bookmark Tab")
	}
}
