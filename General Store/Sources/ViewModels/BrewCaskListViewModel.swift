//
//  BrewCaskListViewModel.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Moya

protocol BrewCaskListViewModelInput {
	var reload: AnyObserver<()> { get }
}

protocol BrewCaskListViewModelOutput {
	var items: Observable<[BrewCaskViewItemModel]> { get }
}

final class BrewCaskListViewModel: BrewCaskListViewModelInput, BrewCaskListViewModelOutput {
	
	// MARK: Inputs
	let reload: AnyObserver<()>
	
	// MARK: Outputs
	let items: Observable<[BrewCaskViewItemModel]>
	
	private let disposeBag = DisposeBag()
	
	init() {
		let _reload = BehaviorRelay<()>(value: ())
		reload = _reload.asObserver()
		
		let _items = BehaviorRelay<[BrewCaskViewItemModel]>(value: [])
		items = _items.asObservable()

		let provider = MoyaProvider<Homebrew>()
		_reload
			.flatMap { provider.rx.request(.caskList) }
			.filterSuccessfulStatusCodes()
			.map([CaskModel].self)
			.map { $0.map(BrewCaskViewItemModel.init(model: )) }
			.bind(to: _items)
			.disposed(by: disposeBag)
	}
}
