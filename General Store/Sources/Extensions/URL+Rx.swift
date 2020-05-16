//
//  URL+Rx.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/16.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift

extension URL: ReactiveCompatible {}

extension Reactive where Base == URL {
	public var write: AnyObserver<Data> {
		.init { event in
			guard case .next(let element) = event else { return }
			do {
				try element.write(to: self.base)
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}
