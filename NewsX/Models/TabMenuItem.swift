//
//  TabMenuItem.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/25/21.
//

import Foundation


/// Menu item for tab view
enum TabMenuItem: String {
	case news
	case search
	case saved
	
	var text: String { rawValue.capitalized }
	var systemImage: String {
		switch self {
			case .news:
				return "newspaper"
			case .search:
				return "magnifyingglass"
			case .saved:
				return "bookmark"
		}
	}
	
//	init(menuItem: MenuItem.ID?) {
//		switch MenuItem(id: menuItem) {
//			case .search: self = .search
//			case .saved: self = .saved
//			default: self = .news
//		}
//	}
}



extension TabMenuItem: Identifiable {
	var id: Self { self }
}
