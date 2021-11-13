//
//  NewsAPI.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/11/21.
//

import Foundation


struct NewsAPI {
	private init() {}
	/// Singleton
	static let shared: NewsAPI = .init()

	/// Shared URL session
	private let session = URLSession.shared
	/// Private API Key from `newsapi.org`
	private let apiKey: String = ""
	
	/// JSON Decoder with `.iso8601` strategy
	private let jsonDecoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()
	
	/// Get all Articles async
	func fetch(from category: Category) async throws -> [Article] {
		let url = generateNewsURL(from: category)
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
	
	private func generateNewsURL(from category: Category) -> URL {
		var url = "https://newsapi.org/v2/top-headlines?"
		url += "apiKey=\(apiKey)"
		url += "&language=ru"
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
