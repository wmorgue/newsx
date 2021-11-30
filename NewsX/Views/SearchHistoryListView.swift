//
//  SearchHistoryListView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/19/21.
//

import SwiftUI


/// List that shows search history
struct SearchHistoryListView: View {
	@ObservedObject var searchVM: ArticleSearchViewModel
	let onSubmit: (String) -> Void
	
	var body: some View {
		List {
			HStack {
				Text("Recently searched")
				Spacer()
				removeAllHistoryButton
			}
			.listRowSeparator(.hidden)
			
			ForEach(searchVM.history, id: \.self) { history in
				Button(history) {
					onSubmit(history)
				}
				.swipeActions { removeHistorySwipe(history) }
			}
		}
		.listStyle(.plain)
	}
}


extension SearchHistoryListView {
	/// Button that clear search history
	private var removeAllHistoryButton: some View {
		Button {
			searchVM.removeAllHistory()
		} label: {
			Text("Clear")
		}
		.foregroundColor(.accentColor)
	}
	
	/// Swipe that remove search history text
	private func removeHistorySwipe(_ historyText: String) -> some View {
		Button(role: .destructive) {
			searchVM.removeHistory(historyText)
		} label: {
			Label("Delete", systemImage: "trash")
		}
	}
}


struct SearchHistoryListView_Previews: PreviewProvider {
	static var previews: some View {
		SearchHistoryListView(searchVM: ArticleSearchViewModel()) { _ in
			
		}
	}
}
