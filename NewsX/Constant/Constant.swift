//
//  Constant.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/10/21.
//

import SwiftUI


/// Provided a constant for specific UI
final class Constant {
	/// List Insets with 0 everyvere
	static var listInsets: EdgeInsets {
		.init(top: 0, leading: 0, bottom: 0, trailing: 0)
	}
	/// Image Transaction for `AsyncImage()`
	static let imageTransaction = Transaction(animation: .easeInOut)
}
