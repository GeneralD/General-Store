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
import RxNimble
import Moya
@testable import General_Store

class General_StoreSpec: QuickSpec {
	
	override func spec() {
		describe("Moya Provider") {
			context("makes models from local sample data") {
				it("as cask model") {
					let provider = MoyaProvider<Homebrew>(stubClosure: MoyaProvider.immediatelyStub)
					let count = provider.rx.request(.caskList)
						.filterSuccessfulStatusCodes()
						.map([CaskModel].self)
						.map { $0.count }
					expect(count).first() == 11
				}
				
				it("as formula model") {
					let provider = MoyaProvider<Homebrew>(stubClosure: MoyaProvider.immediatelyStub)
					let count = provider.rx.request(.formulaList)
						.filterSuccessfulStatusCodes()
						.map([FormulaModel].self)
						.map { $0.count }
					expect(count).first() == 5
				}
			}
		}
	}
}
