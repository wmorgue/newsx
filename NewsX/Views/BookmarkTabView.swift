//
//  BookmarkTabView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/16/21.
//

import SwiftUI


/// A view that shows the bookmark tab.
struct BookmarkTabView: View {
	@State private var searchText: String = ""
	@EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
	
	var body: some View {
		ArticleListView(articles: articles)
			.overlay(bookmarkOverlay(isEmpty: articles.isEmpty))
			.navigationTitle("Saved articles")
			.searchable(text: $searchText)
	}
}

extension BookmarkTabView {
	/// If bookmarks is empty showing this view
	/// - Parameter isEmpty: If bookmarks not found showing text, image and hide navigation bar
	/// - Returns: Empty placeholder view
	@ViewBuilder
	private func bookmarkOverlay(isEmpty: Bool) -> some View {
		if isEmpty {
			EmptyPlaceholderView(text: "No saved bookmarks") {
				Image(systemName: "bookmark.slash")
			}
		}
	}
	
	
	/// Filtered articles by title or description text
	private var articles: [Article] {
		guard !searchText.isEmpty else { return articleBookmarkVM.bookmarks }
		
		return articleBookmarkVM.bookmarks
			.filter {
				$0.title.lowercased().contains(searchText.lowercased()) ||
				$0.descriptionText.lowercased().contains(searchText.lowercased())
			}
	}
}

struct BookmarkTabView_Previews: PreviewProvider {
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
	
	static var previews: some View {
		BookmarkTabView()
			.environmentObject(articleBookmarkVM)
			.previewDisplayName("Bookmark Tab")
	}
}
