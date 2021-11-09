//
//  ArticleRowView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/9/21.
//

import SwiftUI

struct ArticleRowView: View {
	let article: Article
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			// TODO: Refactor to AsyncImageView()
			AsyncImage(url: article.imageURL) { asyncImagePhase in
				switch asyncImagePhase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
					case .failure:
						HStack {
							Spacer()
							VStack(spacing: 25) {
								Image(systemName: "photo.on.rectangle")
									.font(.title)
									.imageScale(.large)
								Text("Can't load the image.")
									.foregroundColor(.gray)
							}
							Spacer()
						}
					case .empty:
						HStack {
							Spacer()
							ProgressView()
							Spacer()
						}
					@unknown default:
						EmptyView()
				}
			}
			.frame(minHeight: 200, maxHeight: 300)
			.background(.regularMaterial)
			.clipped()
		}
		
		VStack(alignment: .leading, spacing: 8) {
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
				
				// TODO: Refactor
				Button {
					print("Add to bookmark")
				} label: {
					Image(systemName: "bookmark")
						.buttonStyle(.bordered)
				}
				
				// TODO: Refactor
				Button {
					print("Share")
				} label: {
					Image(systemName: "square.and.arrow.up")
				}
				
			}
		}
		.padding()
	}
}

struct ArticleRowView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			List {
				ArticleRowView(article: .previewData[0])
					.listRowInsets(
						.init(top: 0, leading: 0, bottom: 0, trailing: 0)
					)
			}
			.listStyle(.plain)
		}
		.previewDisplayName("Article Row")
	}
}
