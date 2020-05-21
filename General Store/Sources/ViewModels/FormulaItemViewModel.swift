//
//  FormulaItemViewModel.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/17.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Alamofire
import RxAlamofire
import SwiftShell

protocol FormulaItemViewModelInput {
	var model: AnyObserver<FormulaModel> { get }
	var browseClick: AnyObserver<()> { get }
	var downloadClick: AnyObserver<()> { get }
	var installClick: AnyObserver<()> { get }
}

protocol FormulaItemViewModelOutput {
	var name: Observable<String?> { get }
	var version: Observable<String?> { get }
}

final class FormulaItemViewModel: FormulaItemViewModelInput, FormulaItemViewModelOutput {
	
	// MARK: Inputs
	let model: AnyObserver<FormulaModel>
	let browseClick: AnyObserver<()>
	let downloadClick: AnyObserver<()>
	let installClick: AnyObserver<()>
	
	// MARK: Outputs
	let name: Observable<String?>
	let version: Observable<String?>
	
	private let disposeBag = DisposeBag()
	
	init(model: FormulaModel) {
		let _model = BehaviorRelay<FormulaModel>(value: model)
		self.model = _model.asObserver()
		
		let _browseClick = PublishRelay<()>()
		self.browseClick = _browseClick.asObserver()
		
		let _downloadClick = PublishRelay<()>()
		self.downloadClick = _downloadClick.asObserver()
		
		let _installClick = PublishRelay<()>()
		self.installClick = _installClick.asObserver()
		
		let _name = BehaviorRelay<String?>(value: nil)
		self.name = _name.asObservable()
		
		let _version = BehaviorRelay<String?>(value: nil)
		self.version = _version.asObservable()
		
		_model
			.map { $0.full_name }
			.asDriver(onErrorJustReturn: nil)
			.drive(_name)
			.disposed(by: disposeBag)
		
		_model
			.map { $0.versions.stable }
			.asDriver(onErrorJustReturn: nil)
			.drive(_version)
			.disposed(by: disposeBag)
		
		_browseClick
			.map { _model.value.homepage }
			.subscribe(onNext: { NSWorkspace.shared.open($0) })
			.disposed(by: disposeBag)
		
		let userDownloadUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
		_downloadClick
			.compactMap { _model.value.binaryUrl }
			.flatMap { url in AF.rx.data(.get, url) }
			.bind(to: userDownloadUrl.appendingPathComponent(_model.value.binaryUrl?.lastPathComponent ?? "binary").rx.write)
			.disposed(by: disposeBag)
		
		let command = "/usr/local/bin/brew"
		_installClick
			.flatMap { runAsync(command, "install", _model.value.name, "--force").rx.response }
			.subscribe(onNext: { print($0.read()) })
			.disposed(by: disposeBag)
	}
}
