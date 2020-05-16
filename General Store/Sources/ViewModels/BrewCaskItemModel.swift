//
//  BrewCaskItemModel.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol BrewCaskItemModelInput {
	var model: AnyObserver<CaskModel> { get }
}

protocol BrewCaskItemModelOutput {
	var name: Observable<String?> { get }
}

final class BrewCaskItemModel: BrewCaskItemModelInput, BrewCaskItemModelOutput {
	
	// MARK: Inputs
	let model: AnyObserver<CaskModel>
	
	// MARK: Outputs
	let name: Observable<String?>
	
	private let disposeBag = DisposeBag()
	
	init(model: CaskModel) {
		let _model = BehaviorRelay<CaskModel>(value: model)
		self.model = _model.asObserver()
		
		let _name = BehaviorRelay<String?>(value: nil)
		self.name = _name.asObservable()
		
		_model
			.map { $0.name.first }
			.asDriver(onErrorJustReturn: nil)
			.drive(_name)
			.disposed(by: disposeBag)
	}
}
