//
//  SidebarContentView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/22/21.
//

import SwiftUI

struct SidebarContentView: View {
	
	private let savedAndSearchMenu: [MenuItem] = [.saved, .search]
	@State private var selectedMenu: MenuItem.ID? = MenuItem.category(.general).id
	
	
	var body: some View {
		NavigationView {
			List(selection: $selectedMenu) {
				ForEach(savedAndSearchMenu) {
					navigationLinkForMenuItem($0)
				}
				
				Section {
					ForEach(Category.menuItems) {
						navigationLinkForMenuItem($0)
					}
				} header: {
					Text("Categories")
				}
				.navigationTitle("News X")
			}
			.listStyle(.sidebar)
		}
	}
}


extension SidebarContentView {
	private func navigationLinkForMenuItem(_ item: MenuItem) -> some View {
		NavigationLink(tag: item.id, selection: $selectedMenu) {
			viewForMenuItem(item)
		} label: {
			Label(item.text, systemImage: item.systemImage)
		}
	}
	
	
	@ViewBuilder
	private func viewForMenuItem(_ item: MenuItem) -> some View {
		switch item {
			case .saved: BookmarkTabView()
			case .search: SearchTabView()
			case .category(let category): NewsTabView(category: category)
		}
	}
}


struct SidebarContentView_Previews: PreviewProvider {
	static var previews: some View {
		SidebarContentView()
			.previewDisplayName("Sidebar")
			.previewInterfaceOrientation(.landscapeLeft)
	}
}
