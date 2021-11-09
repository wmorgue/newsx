//
//  NewsAPIResponse.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/9/21.
//

import Foundation


struct NewsAPIResponse: Decodable {
	let status: String
	let totalResults: Int?
	let articles: [Article]?
	
	let code: String?
	let message: String?
}
