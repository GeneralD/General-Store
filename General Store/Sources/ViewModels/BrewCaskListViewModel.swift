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
import RxAlamofire
import Alamofire
import SwiftyJSON
import Curry

protocol BrewCaskListViewModelInput {
	var reload: AnyObserver<()> { get }
}

protocol BrewCaskListViewModelOutput {
	var items: Observable<[BrewCaskItemModel]> { get }
}

final class BrewCaskListViewModel: BrewCaskListViewModelInput, BrewCaskListViewModelOutput {
	
	// MARK: Inputs
	let reload: AnyObserver<()>
	
	// MARK: Outputs
	let items: Observable<[BrewCaskItemModel]>
	
	private let disposeBag = DisposeBag()
	
	init() {
		let _reload = BehaviorRelay<()>(value: ())
		reload = _reload.asObserver()
		
		let _items = BehaviorRelay<[BrewCaskItemModel]>(value: [])
		items = _items.asObservable()
		
		_reload
			.flatMap { RxAlamofire.data(.get, "https://formulae.brew.sh/api/cask.json") }
			.compactMap { try? JSON(data: $0) }
			.map { $0.arrayValue.map(BrewCaskItemModel.init(json: )) }
			.bind(to: _items)
			.disposed(by: disposeBag)
	}
}
