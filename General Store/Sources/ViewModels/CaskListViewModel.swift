//
//  CaskListViewModel.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Moya

protocol CaskListViewModelInput {
	var reload: AnyObserver<()> { get }
}

protocol CaskListViewModelOutput {
	var items: Observable<[CaskItemViewModel]> { get }
}

final class CaskListViewModel: CaskListViewModelInput, CaskListViewModelOutput {
	
	// MARK: Inputs
	@RxTrigger var reload: AnyObserver<()>
	
	// MARK: Outputs
	@RxProperty(value: []) var items: Observable<[CaskItemViewModel]>
	
	private let disposeBag = DisposeBag()
	
	init() {
		let provider = MoyaProvider<Homebrew>()
		
		Observable.just(())
			.concat($reload)
			.flatMap { provider.rx.request(.caskList) }
			.filterSuccessfulStatusCodes()
			.map([CaskModel].self)
			.map { $0.map(CaskItemViewModel.init(model: )) }
			.bind(to: $items)
			.disposed(by: disposeBag)
	}
}
