//
//  SearchTabView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/17/21.
//

import SwiftUI

struct SearchTabView: View {
	@StateObject var searchVM = ArticleSearchViewModel()
	
	var body: some View {
		NavigationView {
			ArticleListView(articles: articles)
				.overlay(searchOverlay)
				.navigationTitle("Search")
		}
		.searchable(text: $searchVM.searchQuery)
		.onChange(of: searchVM.searchQuery) { query in
			// If search cancelled by button, set phase to empty
			// and show EmptyPlaceholderView
			guard !query.isEmpty else {
				return searchVM.dataFetchPhase = .empty
			}
		}
		.onSubmit(of: .search, search)
	}
}


extension SearchTabView {
	private var articles: [Article] {
		if case .success(let article) = searchVM.dataFetchPhase {
			return article
		} else {
			return []
		}
	}
	
	@ViewBuilder
	private var searchOverlay: some View {
		switch searchVM.dataFetchPhase {
			case .empty:
				if !searchVM.searchQuery.isEmpty {
					ProgressView()
				} else {
					EmptyPlaceholderView(text: "Type to search news") {
						Image(systemName: "magnifyingglass")
					}
				}
			case .success(let articles) where articles.isEmpty:
				EmptyPlaceholderView(text: "No search result found") {
					Image(systemName: "magnifyingglass")
				}
			case .failure(let error):
				RetryView(text: error.localizedDescription, retryAction: search)
			default: EmptyView()
		}
	}
	
	private func search() {
		Task {
			await searchVM.searchArticle()
		}
	}
}


struct SearchTabView_Previews: PreviewProvider {
	@StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
	
	static var previews: some View {
		SearchTabView()
			.environmentObject(bookmarkVM)
			.previewDisplayName("Search Tab")
	}
}
