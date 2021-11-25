//
//  NewsXApp.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/8/21.
//

import SwiftUI


@main
struct NewsXApp: App {
	
	@StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
	
	var body: some Scene {
		WindowGroup {
			MainView()
				.environmentObject(articleBookmarkVM)
		}
	}
}
