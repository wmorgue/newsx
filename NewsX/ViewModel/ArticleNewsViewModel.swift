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

@MainActor
final class ArticleNewsViewModel {
	private let newsAPI = NewsAPI.shared
	
	@Published var selectedCatagory: Category
	@Published var phase = DataFetchPhase<[Article]>.empy
	
	init(articles: [Article]? = nil, selectedCategory: Category = .general) {
		if let articles = articles {
			self.phase = .success(articles)
		} else {
			self.phase = .empy
		}
		self.selectedCatagory = selectedCategory
	}
	
	func loadArticles() async {
		phase = .empy
		do {
			let articles = try await newsAPI.fetch(from: selectedCatagory)
			phase = .success(articles)
		} catch {
			phase = .failure(error)
		}
	}
}



extension ArticleNewsViewModel: ObservableObject {}
