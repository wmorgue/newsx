//
//  Article.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/8/21.
//

import Foundation

fileprivate let relativeDate = RelativeDateTimeFormatter()

struct Source {
	let name: String
}

struct Article {
	let source: Source
	let title: String
	let url: String
	let publishedAt: Date
	
	let author: String?
	let description: String?
	let urlToImage: String?
	
	var authorText: String { author ?? "" }
	var articleURL: URL { URL(string: url)! }
	var descriptionText: String { description ?? "" }
	var imageURL: URL? {
		guard let image = urlToImage else { return nil }
		return URL(string: image)
	}
	var captionText: String {
		"\(source.name) · \(relativeDate.localizedString(for: publishedAt, relativeTo: Date()))"
	}
}


extension Article {
	/// Return array of articles from `News.json`
	static var previewData: [Article] {
		let previewDataURL = Bundle.main.url(forResource: "News", withExtension: "json")!
		let jsonDecoder = JSONDecoder()
		jsonDecoder.dateDecodingStrategy = .iso8601
		
		let data = try! Data(contentsOf: previewDataURL)
		let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
		
		return apiResponse.articles ?? []
	}
}


extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {
	var id: String { url }
}

extension Source: Codable {}
extension Source: Equatable {}
