//
//  DataStore.swift
//  NewsX
//
//  Created by Nikita Rossik on 11/16/21.
//

import Foundation



/// Actor data store
protocol DataStore: Actor {
	associatedtype D
	
	func save(_ current: D)
	func load() -> D?
}


/// Local `.plist`  data store  for Model
actor PlistDataStore<T: Codable>: DataStore where T: Equatable {
	let filename: String
	private var saved: T?
	
	init(filename: String) {
		self.filename = filename
	}
	
	private var dataURL: URL {
		FileManager
			.default
			.urls(for: .documentDirectory, in: .userDomainMask)[0]
			.appendingPathComponent("\(filename).plist")
	}
	
	
	/// Save current generic object to local storage
	/// - Parameter current: Current model
	func save(_ current: T) {
		if let saved = self.saved, saved == current {
			return
		}
		
		do {
			let encoder = PropertyListEncoder()
			encoder.outputFormat = .binary
			
			let data = try encoder.encode(current)
			try data.write(to: dataURL, options: [.atomic])
			
			self.saved = current
		} catch {
			print(error.localizedDescription)
		}
	}
	
	/// Load a `.plist` from local storage
	/// - Returns: `.plist` data or nil
	func load() -> T? {
		do {
			let data = try Data(contentsOf: dataURL)
			let decoder = PropertyListDecoder()
			let current = try decoder.decode(T.self, from: data)
			self.saved = current
			
			return current
		} catch {
			print(error.localizedDescription)
			return nil
		}
	}
}
