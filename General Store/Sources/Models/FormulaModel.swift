//
//  FormulaModel.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/17.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation

struct FormulaModel: Codable {
	let name: String
	let full_name: String
	let desc: String
	let homepage: URL
	let urls: Urls
	let revision: Int
	let version_scheme: Int
	let versions: Versions
	let bottle: Bottle
	
	struct Versions: Codable {
		let stable: String
		let devel: String?
		let head: String?
		let bottle: Bool
	}
	
	struct Urls: Codable {
		let stable: Channel
		let devel: Channel?
		let head: Channel?
		
		struct Channel: Codable {
			let url: URL
			let tag: String?
			let revision: String?
		}
	}
	
	struct Bottle: Codable {
		let stable: Channel
		let devel: Channel?
		let head: Channel?
		
		struct Channel: Codable {
			typealias OSName = String
			let rebuild: Int
			let files: [OSName: Link]
		}
		
		struct Link: Codable {
			let url: String
			let sha256: String
		}
	}
}
