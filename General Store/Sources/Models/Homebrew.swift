//
//  Homebrew.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/16.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Moya

enum Homebrew {
	case caskList
}

extension Homebrew: TargetType {
	var baseURL: URL {
		URL(string: "https://formulae.brew.sh/api")!
	}
	
	var path: String {
		switch self {
		case .caskList:
			return "/cask.json"
		}
	}
	
	var method: Moya.Method {
		.get
	}
	
	var sampleData: Data {
		switch self {
		case .caskList:
			return Bundle.main.path(forResource: "cask", ofType: "json")
				.flatMap(FileHandle.init(forReadingAtPath: ))?
				.readDataToEndOfFile() ?? .init()
		}
	}
	
	var task: Task {
		.requestPlain
	}
	
	var headers: [String : String]? {
		.none
	}
}
