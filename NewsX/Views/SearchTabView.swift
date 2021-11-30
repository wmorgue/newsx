//
//  SearchTabView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/17/21.
//

import SwiftUI


/// A view that shows the search tab.
struct SearchTabView: View {
	@StateObject var searchVM = ArticleSearchViewModel()
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	
	var body: some View {
		ArticleListView(articles: articles)
			.overlay(searchOverlay)
			.navigationTitle("Search")
			.searchable(text: $searchVM.searchQuery, placement: searchFieldPlacement, prompt: "Search article") { searchSuggestions }
			.onChange(of: searchVM.searchQuery) { query in
				// If search cancelled by hit the button,
				// set phase to empty and show EmptyPlaceholderView
				guard !query.isEmpty else {
					return searchVM.dataFetchPhase = .empty
				}
			}
			.onSubmit(of: .search, search)
	}
}


extension SearchTabView {
	/// If fetch phase is success return article or empty
	private var articles: [Article] {
		if case .success(let article) = searchVM.dataFetchPhase {
			return article
		} else {
			return []
		}
	}
	
	/// Search overlay depends on fetch phase
	@ViewBuilder
	private var searchOverlay: some View {
		switch searchVM.dataFetchPhase {
			case .empty:
				if !searchVM.searchQuery.isEmpty {
					ProgressView()
				} else if !searchVM.history.isEmpty {
					SearchHistoryListView(searchVM: searchVM) { newValue in
						searchVM.searchQuery = newValue
					}
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
			default:
				EmptyView()
		}
	}
	
	/// Search field depend on device orientation
	private var searchFieldPlacement: SearchFieldPlacement {
		horizontalSizeClass == .regular ? .navigationBarDrawer : .automatic
	}
	
	/// Search article by text and add it to history
	private func search() {
		let trimmedSearchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
		
		if !trimmedSearchQuery.isEmpty { searchVM.addHistory(trimmedSearchQuery) }
		
		Task {
			await searchVM.searchArticle()
		}
	}
	
	/// Suggestions for searching
	@ViewBuilder
	private var searchSuggestions: some View {
		let keywords = ["Apple", "iOS 15", "Genshin Impact", "Elon Musk"]
		
		ForEach(keywords, id: \.self) { text in
			Button {
				searchVM.searchQuery = text
			} label: {
				Text(text)
			}
		}
	}
}


struct SearchTabView_Previews: PreviewProvider {
	@StateObject static var bookmarkVM = ArticleBookmarkViewModel()
	
	static var previews: some View {
		SearchTabView()
			.environmentObject(bookmarkVM)
			.previewDisplayName("Search Tab")
			.preferredColorScheme(.dark)
	}
}
