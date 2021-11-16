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
	/// Singleton
	static let shared = ArticleBookmarkViewModel()
	/// Default empty array
	@Published private(set) var bookmarks: [Article] = []
	
	private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")
	
	
	private init() {
		Task { await load() }
	}
	
	private func load() async {
		bookmarks = await bookmarkStore.load() ?? []
	}
	
	/// Check if article is bookmarked
	/// - Parameter article: Article model
	/// - Returns: Bool condition
	func isBookmarked(for article: Article) -> Bool {
		bookmarks.first { article.id == $0.id } != nil
	}
	
	/// Add new bookmark of Article at 0 index
	/// - Parameter article: Article model
	func addBookmark(for article: Article) async {
		guard !isBookmarked(for: article) else { return }
		bookmarks.insert(article, at: 0)
		await updateBookmark()
	}
	
	/// Remove bookmark from first index
	/// - Parameter article: Article model
	func removeBookmark(for article: Article) async {
		guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else { return }
		bookmarks.remove(at: index)
		await updateBookmark()
	}
	
	private func updateBookmark() async {
		let bookmarks = self.bookmarks
		await bookmarkStore.save(bookmarks)
	}
}


extension ArticleBookmarkViewModel: ObservableObject {}
