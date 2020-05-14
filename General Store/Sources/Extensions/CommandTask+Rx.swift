//
//  CommandTask+Rx.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift

extension CommandTask: ReactiveCompatible {}

extension Reactive where Base: CommandTask {
	var response: Observable<String> {
		.create { [weak base] (observer: AnyObserver<String>) -> Disposable in
			_ = base?.addObserver { str in
				observer.onNext(str)
			}.addCompletionHandler {
				observer.onCompleted()
			}.launch()
			return Disposables.create {
				base?.resetObserver()
			}
		}
	}
}
