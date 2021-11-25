//
//  ArticleSearchViewModel.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/17/21.
//

import SwiftUI



/// View model for search
@MainActor
final class ArticleSearchViewModel {
	
	static let shared = ArticleSearchViewModel()
	
	/// Load history when VM is init
	private init() {
		loadHistory()
	}
	
	@Published var history: [String] = []
	@Published var searchQuery: String = ""
	@Published var dataFetchPhase: DataFetchPhase<[Article]> = .empty
	
	private let historyLimit = 10
	private var newsAPI = NewsAPI.shared
	private var historyDataStore = PlistDataStore<[String]>(filename: "search history")
	private var trimmedSearchQuery: String {
		searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	
	/// Added a text to history and update storage
	/// - Parameter text: Text query
	func addHistory(_ text: String) {
		guard history.count != historyLimit else {
			history.removeLast()
			return
		}
		
		if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
			history.remove(at: index)
		}
		
		history.insert(text, at: 0)
		updateHistory()
	}
	
	
	/// Remove text from history storage
	/// - Parameter text: Text query
	func removeHistory(_ text: String) {
		guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) else { return }
		history.remove(at: index)
		updateHistory()
	}
	
	
	/// Clean up all search history
	func removeAllHistory() {
		history.removeAll()
		updateHistory()
	}
	
	/// Load history from `historyDataStore` data store or return empty storage
	private func loadHistory() {
		Task {
			history = await historyDataStore.load() ?? []
		}
	}
	
	/// Save search history from array
	private func updateHistory() {
		let currentHistory = self.history
		Task {
			await historyDataStore.save(currentHistory)
		}
	}
	
	
	/// Search articles by input query
	func searchArticle() async {
		guard !Task.isCancelled else { return }
		dataFetchPhase = .empty
		guard !trimmedSearchQuery.isEmpty else { return }
		
		do {
			let articles = try await newsAPI.search(for: searchQuery)
			guard !Task.isCancelled else { return }
			guard trimmedSearchQuery == self.searchQuery else { return }
			dataFetchPhase = .success(articles)
		} catch {
			guard !Task.isCancelled else { return }
			guard trimmedSearchQuery == self.searchQuery else { return }
			dataFetchPhase = .failure(error)
		}
	}
}


extension ArticleSearchViewModel: ObservableObject {}
