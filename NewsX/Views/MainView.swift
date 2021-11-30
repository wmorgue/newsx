//
//  MainView.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/15/21.
//

import SwiftUI

/// Main root view for Application
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
	@StateObject static var articleBookmarkVM = ArticleBookmarkViewModel()
	
	static var previews: some View {
		MainView()
			.environmentObject(articleBookmarkVM)
			.previewDisplayName("Main screen")
			.previewInterfaceOrientation(.portrait)
	}
}
