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
	var browseClick: AnyObserver<()> { get }
	var downloadClick: AnyObserver<()> { get }
	var installClick: AnyObserver<()> { get }
	var uninstallClick: AnyObserver<()> { get }
}

protocol FormulaItemViewModelOutput {
	var name: Observable<String?> { get }
	var version: Observable<String?> { get }
}

final class FormulaItemViewModel: FormulaItemViewModelInput, FormulaItemViewModelOutput {
	
	// MARK: Inputs
	@RxTrigger var browseClick: AnyObserver<()>
	@RxTrigger var downloadClick: AnyObserver<()>
	@RxTrigger var installClick: AnyObserver<()>
	@RxTrigger var uninstallClick: AnyObserver<()>
	
	// MARK: Outputs
	@RxProperty(value: nil) var name: Observable<String?>
	@RxProperty(value: nil) var version: Observable<String?>
	
	private let disposeBag = DisposeBag()
	
	init(model: FormulaModel) {
		let _model = BehaviorRelay<FormulaModel>(value: model)
		
		_model
			.map(\.full_name)
			.asDriver(onErrorJustReturn: nil)
			.drive($name)
			.disposed(by: disposeBag)
		
		_model
			.map(\.versions.stable)
			.asDriver(onErrorJustReturn: nil)
			.drive($version)
			.disposed(by: disposeBag)
		
		$browseClick
			.map { _model.value.homepage }
			.subscribe(onNext: { NSWorkspace.shared.open($0) })
			.disposed(by: disposeBag)
		
		let userDownloadUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
		$downloadClick
			.compactMap { _model.value.binaryUrl }
			.flatMap { url in AF.rx.data(.get, url) }
			.bind(to: userDownloadUrl.appendingPathComponent(_model.value.binaryUrl?.lastPathComponent ?? "binary").rx.write)
			.disposed(by: disposeBag)
		
		let command = "/usr/local/bin/brew"
		$installClick
			.flatMap { runAsync(command, "install", _model.value.name, "--force").rx.response }
			.subscribe(
				onNext: { print($0.read()) },
				onError: { e in (e as? StdError).map { print($0.stream.read()) } },
				onCompleted: { print("Installing \(model.name) has completed.") })
			.disposed(by: disposeBag)
		
		$uninstallClick
			.flatMap { runAsync(command, "uninstall", _model.value.name, "--force").rx.response }
			.subscribe(
				onNext: { print($0.read()) },
				onError: { e in (e as? StdError).map { print($0.stream.read()) } },
				onCompleted: { print("Uninstalling \(model.name) has completed.") })
			.disposed(by: disposeBag)
	}
}
