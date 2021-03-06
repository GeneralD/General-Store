//
//  Homebrew.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/16.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Moya

enum Homebrew {
	case formulaList
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
		case .formulaList:
			return "/formula.json"
		}
	}
	
	var method: Moya.Method {
		.get
	}
	
	var sampleData: Data {
		switch self {
		case .caskList:
			return data(fromResource: "cask", ofType: "json") ?? .init()
		case .formulaList:
			return data(fromResource: "formula", ofType: "json") ?? .init()
		}
	}
	
	var task: Task {
		.requestPlain
	}
	
	var headers: [String : String]? {
		.none
	}
	
	private func data(fromResource name: String, ofType type: String) -> Data? {
		Bundle.main.path(forResource: name, ofType: type)
			.flatMap(FileHandle.init(forReadingAtPath: ))?
			.readDataToEndOfFile()
	}
}
