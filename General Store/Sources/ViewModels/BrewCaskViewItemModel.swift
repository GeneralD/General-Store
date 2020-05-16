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
import Alamofire
import RxAlamofire

protocol BrewCaskViewItemModelInput {
	var model: AnyObserver<CaskModel> { get }
	var browseClick: AnyObserver<()> { get }
	var downloadClick: AnyObserver<()> { get }
	var installClick: AnyObserver<()> { get }
}

protocol BrewCaskViewItemModelOutput {
	var name: Observable<String?> { get }
}

final class BrewCaskViewItemModel: BrewCaskViewItemModelInput, BrewCaskViewItemModelOutput {
	
	// MARK: Inputs
	let model: AnyObserver<CaskModel>
	let browseClick: AnyObserver<()>
	let downloadClick: AnyObserver<()>
	let installClick: AnyObserver<()>
	
	// MARK: Outputs
	let name: Observable<String?>
	
	private let disposeBag = DisposeBag()
	
	init(model: CaskModel) {
		let _model = BehaviorRelay<CaskModel>(value: model)
		self.model = _model.asObserver()
		
		let _browseClick = PublishRelay<()>()
		self.browseClick = _browseClick.asObserver()
		
		let _downloadClick = PublishRelay<()>()
		self.downloadClick = _downloadClick.asObserver()
		
		let _installClick = PublishRelay<()>()
		self.installClick = _installClick.asObserver()
		
		let _name = BehaviorRelay<String?>(value: nil)
		self.name = _name.asObservable()
		
		_model
			.map { $0.name.first }
			.asDriver(onErrorJustReturn: nil)
			.drive(_name)
			.disposed(by: disposeBag)
		
		_browseClick
			.map { _model.value.homepage }
			.subscribe(onNext: { NSWorkspace.shared.open($0) })
			.disposed(by: disposeBag)
		
		let userDownloadUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
		_downloadClick
			.flatMap { AF.rx.data(.get, _model.value.url) }
			.bind(to: userDownloadUrl.appendingPathComponent(_model.value.url.lastPathComponent).rx.write)
			.disposed(by: disposeBag)
	}
}
