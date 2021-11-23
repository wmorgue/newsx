//
//  MenuItem.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/22/21.
//

import Foundation


/// Menu item's for sidebar
enum MenuItem: CaseIterable {
	case saved
	case search
	case category(Category)
	
	
	/// Human-readable text representation for menu item
	var text: String {
		switch self {
			case .saved: return "Saved"
			case .search: return "Search"
			case .category(let category): return category.text
		}
	}
	
	/// A system symbol image for menu item
	var systemImage: String {
		switch self {
			case .saved: return "bookmark"
			case .search: return "magnifyingglass"
			case .category(let category): return category.systemImage
		}
	}
	
	static var allCases: [MenuItem] {
		return [.saved, .search] + Category.menuItems
	}
}


extension MenuItem: Identifiable {
	var id: String {
		switch self {
			case .saved: return "saved"
			case .search: return "search"
			case .category(let category): return category.rawValue
		}
	}
}

extension Category {
	static var menuItems: [MenuItem] {
		allCases.map { .category($0) }
	}
}
