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
	
	/// Human-readable text representation for category case's
	var text: String {
		// If case general -> "Top Headlines"
		if self == .general { return "Top Headlines" }
		// For other case's return capitalized raw value
		return rawValue.capitalized
	}
	
	/// A system symbol image for category
	var systemImage: String {
		switch self {
			case .general: return "newspaper"
			case .business: return "building.2"
			case .technology: return "laptopcomputer.and.iphone"
			case .entertainment: return "homepodmini.and.appletv"
			case .sports: return "sportscourt"
			case .science: return "brain.head.profile"
			case .health: return "cross"
		}
	}
}


extension Category: Identifiable {
	var id: Self { self }
}
