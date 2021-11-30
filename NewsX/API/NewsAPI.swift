//
//  NewsAPI.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/11/21.
//

import Foundation


struct NewsAPI {

	/// Shared URL session
	private let session = URLSession.shared
	/// Private API Key from `newsapi.org`
	private let apiKey: String = Constant.apiKey
	
	/// JSON Decoder with `.iso8601` strategy
	private let jsonDecoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()
	
	/// Get all Articles async and generate news URL from category
	func fetch(from category: Category) async throws -> [Article] {
		try await fetchArticles(from: generateNewsURL(from: category))
	}
	
	/// Search articles by query
	/// - Parameter query: Text query request
	/// - Returns: Array of articles
	func search(for query: String) async throws -> [Article] {
		try await fetchArticles(from: generateSearchURL(from: query))
	}
	
	/// Fetch all articles
	/// - Parameter url: Specified URL
	/// - Returns: Array of articles
	private func fetchArticles(from url: URL) async throws -> [Article] {
		let (data, response) = try await session.data(from: url)
		
		guard let response = response as? HTTPURLResponse else {
			throw generateError(description: "Bad Response")
		}
		
		switch response.statusCode {
			case (200...299), (400...499):
				let apiResponse: NewsAPIResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
				
				if apiResponse.status == "ok" {
					// Return articles or empty array
					return apiResponse.articles ?? []
				} else {
					throw generateError(description: apiResponse.message ?? "An error occured")
				}
				
			default:
				throw generateError(description: "A server error occured")
		}
	}
	
	
	/// Create a search URL
	/// - Parameter query: Text query
	/// - Returns: Search URL
	private func generateSearchURL(from query: String) -> URL {
		let percentEncodedgString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
		
		var url = "https://newsapi.org/v2/everything?"
		url += "apiKey=\(apiKey)"
		url += "&language=ru"
		url += "&q=\(percentEncodedgString)"
		return URL(string: url)!
	}
	
	
	/// Generate url for news in `Russian` via selected category
	/// - Parameter category: News category, like a technology, business, sport, etc.
	/// - Parameter language: News language region setting's. Default `Russian`.
	/// - Returns: URL string with selected language and category
	private func generateNewsURL(from category: Category, language: String = "ru") -> URL {
		// By default `top-headlines`
		var url = "https://newsapi.org/v2/top-headlines?"
		url += "apiKey=\(apiKey)"
		url += "&language=\(language)"
		url += "&category=\(category.rawValue)"
		return URL(string: url)!
	}
	
	/// Wrapper for NS Error
	/// - Parameters:
	///   - code: status code
	///   - description: system text
	/// - Returns: Information about an error
	private func generateError(code: Int = 1, description: String) -> Error {
		NSError(domain: "NewAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
	}
}
