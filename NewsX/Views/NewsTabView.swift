//
//  NewsTabView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/15/21.
//

import SwiftUI

/// A view that shows the article news.
struct NewsTabView: View {
	
	@State private var angle: Double = 0
	@StateObject var articleNewsVM: ArticleNewsViewModel
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	
	private var fetchTaskToken: FetchTaskToken {
		articleNewsVM.fetchTaskToken
	}
	
	init(articles: [Article]? = nil, category: Category = .general) {
		let articleNewsValue = ArticleNewsViewModel(articles: articles, selectedCategory: category)
		self._articleNewsVM = StateObject(wrappedValue: articleNewsValue)
	}
	
	var body: some View {
		ArticleListView(articles: articles)
			.overlay(overlayView)
			.refreshable(action: refreshTask)
			.task(id: fetchTaskToken, loadArticles)
			.navigationBarTitleDisplayMode(.inline)
			.navigationBarItems(leading: leadingCategoryText, trailing: navigationTrailingItem)
	}
}


extension NewsTabView {
	/// Overlay for current view depens on fetch phase
	///
	/// By default — `EmptyView`.
	@ViewBuilder
	private var overlayView: some View {
		switch articleNewsVM.phase {
			case .empty:
				ProgressView()
			case .success(let result) where result.isEmpty:
				EmptyPlaceholderView(text: "No Articles") {
					Image(systemName: "binoculars")
				}
			case .failure(let error):
				RetryView(text: error.localizedDescription, retryAction: refreshTask)
			default:
				EmptyView()
		}
	}
	
	/// Return article if phase is success or empty array
	private var articles: [Article] {
		if case let .success(articles) = articleNewsVM.phase {
			return articles
		} else {
			return []
		}
	}
	
	/// Load articles
	@Sendable
	private func loadArticles() async {
		await articleNewsVM.loadArticles()
	}
	
	@Sendable
	private func refreshTask() {
		DispatchQueue.main.async {
			articleNewsVM.fetchTaskToken = FetchTaskToken(category: fetchTaskToken.category, token: Date())
		}
	}
	
	
	/// Category text by leading
	private var leadingCategoryText: Text {
		Text(fetchTaskToken.category.text)
	}
	
	@ViewBuilder
	private var navigationTrailingItem: some View {
		switch horizontalSizeClass {
			case .regular: refreshArticleButton
			default: categoryMenu
		}
	}
	
	/// Refresh button
	private var refreshArticleButton: some View {
		Button {
			refreshTask()
			angle += 360
		} label: {
			Image(systemName: "arrow.counterclockwise")
		}
		.rotationEffect(.degrees(angle))
		.animation(.spring(), value: angle)
	}
	
	/// Menu with category
	private var categoryMenu: some View {
		Menu {
			Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
				ForEach(Category.allCases) {
					Text($0.text)
						.tag($0)
				}
			}
		} label: {
			Image(systemName: "fiberchannel")
				.imageScale(.large)
		}
	}
}


struct NewsTabView_Previews: PreviewProvider {
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
	
	static var previews: some View {
		NewsTabView(articles: Article.previewData)
			.environmentObject(articleBookmarkVM)
			.previewDisplayName("News Tab")
	}
}
