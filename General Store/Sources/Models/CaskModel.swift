//
//  CaskModel.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/16.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation

struct CaskModel: Codable {
	let token: String
	let name: [String]
	let homepage: String
	let url: URL
	let appcast: String?
	let version: String
	let sha256: String
}
