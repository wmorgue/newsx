//
//  ArticleNewsViewModel.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/11/21.
//

import SwiftUI


enum DataFetchPhase<T> {
	case empty
	case success(T)
	case failure(Error)
}

struct FetchTaskToken: Equatable {
	/// News category
	var category: Category
	/// Usually date now
	var token: Date
}


/// View model news for article
@MainActor
final class ArticleNewsViewModel {
	private let newsAPI = NewsAPI()
	
	@Published var fetchTaskToken: FetchTaskToken
	@Published var phase = DataFetchPhase<[Article]>.empty
	
	init(articles: [Article]? = nil, selectedCategory: Category = .general) {
		if let articles = articles {
			self.phase = .success(articles)
		} else {
			self.phase = .empty
		}
		self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
	}
	
	/// Async load articles with phase's
	func loadArticles() async {
// Uncomment for development and comment below
//		phase = .success(Article.previewData)
		
		if Task.isCancelled { return }
		phase = .empty
		do {
			let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
			if Task.isCancelled { return }
			phase = .success(articles)
		} catch {
			if Task.isCancelled { return }
			phase = .failure(error)
		}
	}
}



extension ArticleNewsViewModel: ObservableObject {}
