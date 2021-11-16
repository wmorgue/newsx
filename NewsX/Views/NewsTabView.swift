//
//  NewsTabView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/15/21.
//

import SwiftUI

struct NewsTabView: View {
	@StateObject var articleNewsVM = ArticleNewsViewModel()
	private var fetchTaskToken: FetchTaskToken {
		articleNewsVM.fetchTaskToken
	}
	
	var body: some View {
		NavigationView {
			ArticleListView(articles: articles)
				.overlay(overlayView)
				.refreshable(action: refreshTask)
				.task(id: fetchTaskToken, loadArticles)
				.navigationBarTitleDisplayMode(.inline)
				.navigationTitle(fetchTaskToken.category.text)
				.navigationBarItems(trailing: menu)
		}
	}
}


extension NewsTabView {
	@ViewBuilder
	private var overlayView: some View {
		switch articleNewsVM.phase {
			case .empy:
				ProgressView()
			case .success(let result) where result.isEmpty:
				EmptyPlaceholderView(text: "No Articles") {
					nil
				}
			case .failure(let error):
				RetryView(text: error.localizedDescription, retryAction: refreshTask)
			default:
				EmptyView()
		}
	}
	
	private var articles: [Article] {
		if case let .success(articles) = articleNewsVM.phase {
			return articles
		} else {
			return []
		}
	}
	
	@Sendable
	private func loadArticles() async {
		await articleNewsVM.loadArticles()
	}
	
	@Sendable
	private func refreshTask() {
		articleNewsVM.fetchTaskToken = FetchTaskToken(category: fetchTaskToken.category, token: Date())
	}
	
	private var menu: some View {
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
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel()
	
	static var previews: some View {
		let previewData: ArticleNewsViewModel = .init(articles: Article.previewData)
		
		NewsTabView(articleNewsVM: previewData)
			.environmentObject(articleBookmarkVM)
			.previewDisplayName("News Tab")
	}
}
