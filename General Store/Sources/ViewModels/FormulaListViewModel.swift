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
	@RxTrigger var reload: AnyObserver<()>
	
	// MARK: Outputs
	@RxProperty(value: []) var items: Observable<[FormulaItemViewModel]>
	
	private let disposeBag = DisposeBag()
	
	init() {
		let provider = MoyaProvider<Homebrew>()
		
		Observable.just(())
			.concat($reload)
			.flatMap { provider.rx.request(.formulaList) }
			.filterSuccessfulStatusCodes()
			.map([FormulaModel].self)
			.map { $0.map(FormulaItemViewModel.init(model: )) }
			.bind(to: $items)
			.disposed(by: disposeBag)
	}
}
