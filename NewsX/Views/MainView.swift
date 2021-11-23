//
//  MainView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/15/21.
//

import SwiftUI

// TODO: Documentation
struct MainView: View {
	@Environment(\.horizontalSizeClass) var horizontalSizeClass
	
	var body: some View {
		switch horizontalSizeClass {
			case .compact:
				TabContentView()
			default:
				SidebarContentView()
		}
	}
}


struct MainView_Previews: PreviewProvider {
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
	
	static var previews: some View {
		MainView()
			.environmentObject(articleBookmarkVM)
			.previewDisplayName("Main screen")
			.previewInterfaceOrientation(.portrait)
	}
}
