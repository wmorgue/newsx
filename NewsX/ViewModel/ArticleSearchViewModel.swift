//
//  ArticleSearchViewModel.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/17/21.
//

import SwiftUI


// TODO: Documentation
@MainActor
final class ArticleSearchViewModel {
	
	static let shared = ArticleSearchViewModel()
	
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
	
	func removeHistory(_ text: String) {
		guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) else { return }
		history.remove(at: index)
		updateHistory()
	}
	
	func removeAllHistory() {
		history.removeAll()
		updateHistory()
	}
	
	private func loadHistory() {
		Task {
			history = await historyDataStore.load() ?? []
		}
	}
	
	private func updateHistory() {
		let currentHistory = self.history
		Task {
			await historyDataStore.save(currentHistory)
		}
	}
	
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
