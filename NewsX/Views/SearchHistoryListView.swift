//
//  SearchHistoryListView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/19/21.
//

import SwiftUI

// TODO: Documentation
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
				.swipeActions {
					Button(role: .destructive) {
						searchVM.removeHistory(history)
					} label: {
						Label("Delete", systemImage: "trash")
					}
				}
			}
		}
		.listStyle(.plain)
	}
}


extension SearchHistoryListView {
	private var removeAllHistoryButton: some View {
		Button {
			searchVM.removeAllHistory()
		} label: {
			Text("Clear")
		}
		.foregroundColor(.accentColor)
	}
}


struct SearchHistoryListView_Previews: PreviewProvider {
	static var previews: some View {
		SearchHistoryListView(searchVM: ArticleSearchViewModel.shared) { _ in
			
		}
	}
}
