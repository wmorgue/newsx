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
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	
	var body: some View {
		rootView
	}
}


extension ArticleListView {
	private var listView: some View {
		List {
			ForEach(articles) { article in
				ArticleRowView(article)
			}
			.listRowSeparator(.hidden)
			.listRowInsets(Constant.listInsets)
		}
		.listStyle(.plain)
	}
	
	private var columns: [GridItem] {
		[GridItem(.adaptive(minimum: 300), spacing: 8)]
	}
	
	private var gridView: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(articles) { article in
					ArticleRowView(article)
						.frame(height: 360)
						.background(Color(uiColor: .systemBackground))
						.mask(RoundedRectangle(cornerRadius: 8))
						.shadow(radius: 4)
						.padding(.bottom, 4)
				}
			}
			.padding()
		}
		.background(Color(uiColor: .secondarySystemGroupedBackground ))
	}
	
	@ViewBuilder
	private var rootView: some View {
		switch horizontalSizeClass {
			case .regular: gridView
			default: listView
		}
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
