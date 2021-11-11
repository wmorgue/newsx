//
//  Category.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/11/21.
//

import Foundation


/// General news category
enum Category: String, CaseIterable {
	case general
	case business
	case technology
	case entertainment
	case sports
	case science
	case health
	
	var text: String {
		// If case general -> "Top Headlines"
		if self == .general { return "Top Headlines" }
		// For other case's return capitalized raw value
		return rawValue.capitalized
	}
}


extension Category: Identifiable {
	var id: Self { self }
}
