//
//  CaskItemViewModel.swift
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
import SwiftShell

protocol CaskItemViewModelInput {
	var browseClick: AnyObserver<()> { get }
	var downloadClick: AnyObserver<()> { get }
	var installClick: AnyObserver<()> { get }
	var uninstallClick: AnyObserver<()> { get }
}

protocol CaskItemViewModelOutput {
	var name: Observable<String?> { get }
	var version: Observable<String?> { get }
}

final class CaskItemViewModel: CaskItemViewModelInput, CaskItemViewModelOutput {
	
	// MARK: Inputs
	@RxTrigger var browseClick: AnyObserver<()>
	@RxTrigger var downloadClick: AnyObserver<()>
	@RxTrigger var installClick: AnyObserver<()>
	@RxTrigger var uninstallClick: AnyObserver<()>
	
	// MARK: Outputs
	@RxProperty(value: nil) var name: Observable<String?>
	@RxProperty(value: nil) var version: Observable<String?>
	
	private let disposeBag = DisposeBag()
	
	init(model: CaskModel) {
		let _model = BehaviorRelay<CaskModel>(value: model)
		
		_model
			.map(\.name.first)
			.asDriver(onErrorJustReturn: nil)
			.drive($name)
			.disposed(by: disposeBag)
		
		_model
			.map(\.version)
			.asDriver(onErrorJustReturn: nil)
			.drive($version)
			.disposed(by: disposeBag)
		
		$browseClick
			.map { _model.value.homepage }
			.subscribe(onNext: { NSWorkspace.shared.open($0) })
			.disposed(by: disposeBag)
		
		let userDownloadUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
		$downloadClick
			.flatMap { AF.rx.data(.get, _model.value.url) }
			.bind(to: userDownloadUrl.appendingPathComponent(_model.value.url.lastPathComponent).rx.write)
			.disposed(by: disposeBag)
		
		let command = "/usr/local/bin/brew"
		$installClick
			.flatMap { runAsync(command, "cask", "install", _model.value.token, "--force").rx.response }
			.subscribe(
				onNext: { print($0.read()) },
				onError: { e in (e as? StdError).map { print($0.stream.read()) } },
				onCompleted: { print("Installing \(model.name) has completed.") })
			.disposed(by: disposeBag)
		
		$uninstallClick
			.flatMap { runAsync(command, "cask", "uninstall", _model.value.token, "--force").rx.response }
			.subscribe(
				onNext: { print($0.read()) },
				onError: { e in (e as? StdError).map { print($0.stream.read()) } },
				onCompleted: { print("Uninstalling \(model.name) has completed.") })
			.disposed(by: disposeBag)
	}
}
