//
//  ArticleRowView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/9/21.
//

import SwiftUI


/// Article Row that contain image, text, subtext, bookmark and share button.
struct ArticleRowView: View {
	
	/// Article model
	let article: Article
	@Environment(\.horizontalSizeClass) private var horizontalSizeClass
	
	init(_ article: Article) { self.article = article }
	
	@EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
	
	var body: some View {
		switch horizontalSizeClass {
			case .regular:
				GeometryReader { contentRowView($0) }
			default:
				contentRowView()
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
	
	/// Sharing button for article
	/// - Parameter proxy: A proxy for access to the size and coordinate space (for anchor resolution) of the container view.
	/// - Returns: Button with system image
	private func sharingArticleButton(_ proxy: GeometryProxy? = nil) -> some View {
		Button {
			presentActionSheet(for: article.articleURL, proxy: proxy)
		} label: {
			Image(systemName: "square.and.arrow.up")
		}
		.buttonStyle(.bordered)
	}
	
	
	
	/// Remove or add bookmark to storage
	/// - Parameter article: Article model
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
	private func presentActionSheet(for url: URL, proxy: GeometryProxy? = nil) {
		let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
		guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
						.keyWindow?
						.rootViewController else { return }
		
		activityVC.popoverPresentationController?.sourceView = rootVC.view
		
		if let proxy = proxy {
			activityVC.popoverPresentationController?.sourceRect = proxy.frame(in: .global)
		}
		
		rootVC.present(activityVC, animated: true)
	}
	
	/// Represent image, title, subtitle, date and buttons to current ArticleRowView
	/// - Parameter proxy: A proxy for access to the size and coordinate space (for anchor resolution) of the container view.
	/// - Returns: Article row content
	@ViewBuilder
	private func contentRowView(_ proxy: GeometryProxy? = nil) -> some View {
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
			.asyncImageFrame(sizeClass: horizontalSizeClass)
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
				
				if horizontalSizeClass == .regular {
					Spacer()
				}
				
				// Caption text and relative date with 2 button's
				HStack(spacing: 14) {
					Text(article.captionText)
						.foregroundColor(.secondary)
						.font(.caption)
						.lineLimit(1)
					
					Spacer()
					
					bookmarkButton
					sharingArticleButton(proxy)
				}
			}
			.padding([.horizontal, .bottom])
		}
	}
}


fileprivate extension View {
	/// Return frame for async image with current Interface Size Class
	/// - Parameter sizeClass: A set of values that indicate the visual size available to the view.
	/// - Returns: Frame for regular and default size class
	@ViewBuilder
	func asyncImageFrame(sizeClass: UserInterfaceSizeClass? = .compact) -> some View {
		switch sizeClass {
			case .regular:
				frame(height: 180)
			default:
				frame(minHeight: 200, maxHeight: 300)
				
		}
	}
}

struct ArticleRowView_Previews: PreviewProvider {
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel()
	
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
