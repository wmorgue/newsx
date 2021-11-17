//
//  ArticleSearchViewModel.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/17/21.
//

import SwiftUI

@MainActor
final class ArticleSearchViewModel {
	private var newsAPI = NewsAPI.shared
	@Published var searchQuery: String = ""
	@Published var dataFetchPhase: DataFetchPhase<[Article]> = .empty
	
	func searchArticle() async {
		guard !Task.isCancelled else { return }
		dataFetchPhase = .empty
		let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard !searchQuery.isEmpty else { return }
		
		do {
			let articles = try await newsAPI.search(for: searchQuery)
			guard !Task.isCancelled else { return }
			dataFetchPhase = .success(articles)
		} catch {
			guard !Task.isCancelled else { return }
			dataFetchPhase = .failure(error)
		}
	}
}


extension ArticleSearchViewModel: ObservableObject {}
