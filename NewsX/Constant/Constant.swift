//
//  Constant.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/10/21.
//

import SwiftUI


/// Provided a constant for specific UI and other stuff
final class Constant {
	/// Private API key,  but available for GitHub 😁
	static let apiKey: String = "c75995c7a7634018829ffdcbb82aeaf1"
	
	/// List Insets with 0 everyvere
	static var listInsets: EdgeInsets {
		.init(top: 0, leading: 0, bottom: 0, trailing: 0)
	}
	/// Image Transaction for `AsyncImage()`
	static let imageTransaction = Transaction(animation: .easeInOut)
}
