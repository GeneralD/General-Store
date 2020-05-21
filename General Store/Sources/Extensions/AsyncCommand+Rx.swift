//
//  AsyncCommand+Rx.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import SwiftShell

extension AsyncCommand: ReactiveCompatible {}

extension Reactive where Base: AsyncCommand {
	var response: Observable<ReadableStream> {
		.create { [weak base] (observer: AnyObserver<ReadableStream>) -> Disposable in
			base?.stdout.onOutput(observer.onNext)
			base?.stderror.onOutput { stream in
				observer.onError(StdError(stream: stream))
			}
			base?.onCompletion { _ in
				observer.onCompleted()
			}
			do {
				try base?.finish()
			} catch {
				observer.onError(error)
			}
			return Disposables.create()
		}
	}
}

struct StdError: Error {
	let stream: ReadableStream
}
