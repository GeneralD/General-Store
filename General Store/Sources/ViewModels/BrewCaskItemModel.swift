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
import SwiftyJSON

protocol BrewCaskItemModelInput {
	var selected: AnyObserver<Int> { get }
}

protocol BrewCaskItemModelOutput {
	var title: Observable<String?> { get }
}

final class BrewCaskItemModel: BrewCaskItemModelInput, BrewCaskItemModelOutput {
	
	// MARK: Inputs
	let selected: AnyObserver<Int>
	
	// MARK: Outputs
	let title: Observable<String?>
	
	private let disposeBag = DisposeBag()
	
	init(json: JSON) {
		let selectedRelay = PublishRelay<Int>()
		selected = selectedRelay.asObserver()
		let titleRelay = BehaviorRelay<String?>(value: nil)
		title = titleRelay.asObservable()
		
		// Do something here...
	}
}
