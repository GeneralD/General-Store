//
//  General_StoreTests.swift
//  General StoreTests
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxBlocking
import Moya
@testable import General_Store

class General_StoreSpec: QuickSpec {
	
	override func spec() {
		
		describe("CommandTask") {
			it("echo a string") {
				let task = CommandTask(launchPath: "/bin/echo", arguments: "abc")
				let result = try! task.rx.response
					.toBlocking()
					.single()
					.trimmingCharacters(in: .whitespacesAndNewlines)
				expect(result) == "abc"
			}
			
			it("gets path to brew") {
				let task = CommandTask(launchPath: "/usr/bin/which", arguments: "brew")
				let result = try! task.rx.response
					.toBlocking()
					.single()
					.trimmingCharacters(in: .whitespacesAndNewlines)
				expect(result) == "/usr/local/bin/brew"
			}
		}
		
		describe("Moya Provider") {
			context("makes models from local sample data") {
				it("as cask model") {
					let provider = MoyaProvider<Homebrew>(stubClosure: MoyaProvider.immediatelyStub)
					let count = try? provider.rx.request(.caskList)
						.filterSuccessfulStatusCodes()
						.map([CaskModel].self)
						.toBlocking()
						.single()
						.count
					expect(count) == 11
				}
				
				it("as formula model") {
					let provider = MoyaProvider<Homebrew>(stubClosure: MoyaProvider.immediatelyStub)
					let count = try? provider.rx.request(.formulaList)
						.filterSuccessfulStatusCodes()
						.map([FormulaModel].self)
						.toBlocking()
						.single()
						.count
					expect(count) == 5
				}
			}
		}
	}
}
