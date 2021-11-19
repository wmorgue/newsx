//
//  ArticleRowView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/9/21.
//

import SwiftUI

// TODO: Documentation
struct ArticleRowView: View {
	
	/// Article model
	let article: Article
	init(_ article: Article) { self.article = article }
	
	@EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			AsyncImage(url: article.imageURL, transaction: Constant.imageTransaction) { asyncImagePhase in
				switch asyncImagePhase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
					case .failure:
						FailureImageView()
					case .empty:
						EmptyImageView()
					@unknown default:
						EmptyView()
				}
			}
			.frame(minHeight: 200, maxHeight: 300)
			.background(.regularMaterial)
			.clipped()
		
		// Article text and description
		VStack(alignment: .leading, spacing: 8) {
			// Uncomment if needed for open article in Safari
			// Link(article.title, destination: article.articleURL)
			Text(article.title)
				.font(.headline)
				.lineLimit(2)
			Text(article.descriptionText)
				.font(.subheadline)
				.lineLimit(3)
			
			// Caption text and relative date with 2 button's
			HStack(spacing: 14) {
				Text(article.captionText)
					.foregroundColor(.secondary)
					.font(.caption)
					.lineLimit(1)
				
				Spacer()
				
				bookmarkButton
				sharingButton
			}
		}
		.padding([.horizontal, .bottom])
		}
	}
}

extension ArticleRowView {
	/// Bookmark button
	private var bookmarkButton: some View {
		Button {
			Task {
				await toggleBookmark(for: article)
			}
		} label: {
			let imageName: String = articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark"
			Image(systemName: imageName)
		}
		.buttonStyle(.bordered)
	}
	
	
	/// Sharing button
	private var sharingButton: some View {
		Button {
			presentActionSheet(for: article.articleURL)
		} label: {
			Image(systemName: "square.and.arrow.up")
		}
		.buttonStyle(.bordered)

	}
	
	private func toggleBookmark(for article: Article) async {
		if articleBookmarkVM.isBookmarked(for: article) {
			await articleBookmarkVM.removeBookmark(for: article)
		} else {
			await articleBookmarkVM.addBookmark(for: article)
		}
	}
	
	/// Present share action sheet for SwiftUI
	///
	/// Call this method when `sharingButton` is tapped.
	private func presentActionSheet(for url: URL) {
		let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		(UIApplication.shared.connectedScenes.first as? UIWindowScene)?
			.keyWindow?
			.rootViewController?
			.present(activityVC, animated: true)
		
	}
}

struct ArticleRowView_Previews: PreviewProvider {
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
	
	static var previews: some View {
		NavigationView {
			List {
				ArticleRowView(.previewData.first!)
					.listRowInsets(Constant.listInsets)
			}
			.listStyle(.plain)
		}
		.environmentObject(articleBookmarkVM)
		.previewDisplayName("Article Row")
	}
}
