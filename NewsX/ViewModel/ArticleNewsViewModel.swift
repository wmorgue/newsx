//
//  ArticleNewsViewModel.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/11/21.
//

import SwiftUI


enum DataFetchPhase<T> {
	case empy
	case success(T)
	case failure(Error)
}

struct FetchTaskToken: Equatable {
	var category: Category
	var token: Date
}

@MainActor
final class ArticleNewsViewModel {
	private let newsAPI = NewsAPI.shared
	
	@Published var fetchTaskToken: FetchTaskToken
	@Published var phase = DataFetchPhase<[Article]>.empy
	
	init(articles: [Article]? = nil, selectedCategory: Category = .general) {
		if let articles = articles {
			self.phase = .success(articles)
		} else {
			self.phase = .empy
		}
		self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
	}
	
	func loadArticles() async {
		if Task.isCancelled { return }
		phase = .empy
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
