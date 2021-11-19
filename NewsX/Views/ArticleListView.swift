//
//  ArticleListView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/10/21.
//

import SwiftUI

// TODO: Documentation
struct ArticleListView: View {
	let articles: [Article]
	
	var body: some View {
		List {
			ForEach(articles) { article in
				ArticleRowView(article)
			}
			.listRowSeparator(.hidden)
			.listRowInsets(Constant.listInsets)
		}
		.listStyle(.plain)
	}
}


struct ArticleListView_Previews: PreviewProvider {
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
	
	static var previews: some View {
		NavigationView {
			ArticleListView(articles: Article.previewData)
				.environmentObject(articleBookmarkVM)
				.previewDisplayName("Article List")
		}
	}
}
