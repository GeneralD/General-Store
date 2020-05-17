//
//  General_StoreTests.swift
//  General StoreTests
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import XCTest
import RxBlocking
import Moya
@testable import General_Store

class General_StoreTests: XCTestCase {
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testCommandTask() throws {
		let task = CommandTask(launchPath: "/bin/echo", arguments: "abc")
		let result = try task.rx.response
			.toBlocking()
			.single()
			.trimmingCharacters(in: .whitespacesAndNewlines)
		XCTAssertEqual(result, "abc")
	}
	
	func testApiProvider1() throws {
		let provider = MoyaProvider<Homebrew>(stubClosure: MoyaProvider.immediatelyStub)
		let count = try? provider.rx.request(.caskList)
			.filterSuccessfulStatusCodes()
			.map([CaskModel].self)
			.toBlocking()
			.single()
			.count
		XCTAssertEqual(count, 11)
	}
	
	func testApiProvider2() throws {
		let provider = MoyaProvider<Homebrew>(stubClosure: MoyaProvider.immediatelyStub)
		let count = try? provider.rx.request(.formulaList)
			.filterSuccessfulStatusCodes()
			.map([FormulaModel].self)
			.toBlocking()
			.single()
			.count
		XCTAssertEqual(count, 5)
	}
}
