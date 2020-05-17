//
//  FormulaListViewModel.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/17.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Moya

protocol FormulaListViewModelInput {
	var reload: AnyObserver<()> { get }
}

protocol FormulaListViewModelOutput {
	var items: Observable<[FormulaItemViewModel]> { get }
}

final class FormulaListViewModel: FormulaListViewModelInput, FormulaListViewModelOutput {
	
	// MARK: Inputs
	let reload: AnyObserver<()>
	
	// MARK: Outputs
	let items: Observable<[FormulaItemViewModel]>
	
	private let disposeBag = DisposeBag()
	
	init() {
		let _reload = BehaviorRelay<()>(value: ())
		reload = _reload.asObserver()
		
		let _items = BehaviorRelay<[FormulaItemViewModel]>(value: [])
		items = _items.asObservable()
		
		let provider = MoyaProvider<Homebrew>()
		_reload
			.flatMap { provider.rx.request(.formulaList) }
			.filterSuccessfulStatusCodes()
			.map([FormulaModel].self)
			.map { $0.map(FormulaItemViewModel.init(model: )) }
			.bind(to: _items)
			.disposed(by: disposeBag)
	}
}
