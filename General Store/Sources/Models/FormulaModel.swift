//
//  FormulaModel.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/17.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GBDeviceInfo

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
			
			private enum CodingKeys: String, CodingKey {
				case url
				case tag
				case revision
			}
			
			init(from decoder: Decoder) throws {
				let values = try decoder.container(keyedBy: CodingKeys.self)
				url = try values.decode(URL.self, forKey: .url)
				tag = try? values.decodeIfPresent(String.self, forKey: .tag)
				revision = try? values.decodeIfPresent(String.self, forKey: .revision) ?? values.decodeIfPresent(Int.self, forKey: .revision)?.description
			}
			
			func encode(to encoder: Encoder) throws {
				var container = encoder.container(keyedBy: CodingKeys.self)
				try container.encode(url, forKey: .url)
				try container.encode(tag, forKey: .tag)
				try container.encode(revision, forKey: .revision)
			}
		}
	}
	
	struct Bottle: Codable {
		let stable: Channel?
		let devel: Channel?
		let head: Channel?
		
		struct Channel: Codable {
			typealias OSName = String
			let rebuild: Int
			let files: [OSName: Link]
		}
		
		struct Link: Codable {
			let url: URL
			let sha256: String
		}
	}
}

extension FormulaModel {
	var sourceUrl: URL? {
		urls.stable.url
	}
	
	var binaryUrl: URL? {
		guard let osName = GBDeviceInfo.deviceInfo()?.osName else { return nil }
		return bottle.stable?.files[osName]?.url ?? bottle.stable?.files.first?.value.url
	}
}
