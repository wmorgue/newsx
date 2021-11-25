//
//  SidebarContentView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/22/21.
//

import SwiftUI

struct SidebarContentView: View {
	
	@AppStorage("selected_item") private var selectedMenu: MenuItem.ID?
	
	private let savedAndSearchMenu: [MenuItem] = [.saved, .search]
	private var selection: Binding<MenuItem.ID?> {
		Binding {
			selectedMenu ?? MenuItem.category(.general).id
		} set: { newValue in
			if let menuItem = newValue {
				selectedMenu = menuItem
			}
		}
	}
	
	
	var body: some View {
		NavigationView {
			List(selection: selection) {
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
		NavigationLink(tag: item.id, selection: selection) {
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
			case .category(let category):
				NewsTabView(category: category)
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
