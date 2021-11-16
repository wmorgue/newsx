//
//  ArticleBookmarkViewModel.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/16/21.
//

import SwiftUI


/// View model bookmarks for article
@MainActor
final class ArticleBookmarkViewModel {
	/// Default empty array
	@Published private(set) var bookmarks: [Article] = []
	
	
	/// Check if article is bookmarked
	/// - Parameter article: Article model
	/// - Returns: Bool condition
	func isBookmarked(for article: Article) -> Bool {
		bookmarks.first { article.id == $0.id } != nil
	}
	
	/// Add new bookmark of Article at 0 index
	/// - Parameter article: Article model
	func addBookmark(for article: Article) {
		guard !isBookmarked(for: article) else { return }
		bookmarks.insert(article, at: 0)
	}
	
	/// Remove bookmark from first index
	/// - Parameter article: Article model
	func removeBookmark(for article: Article) {
		guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else { return }
		bookmarks.remove(at: index)
	}
}


extension ArticleBookmarkViewModel: ObservableObject {}
