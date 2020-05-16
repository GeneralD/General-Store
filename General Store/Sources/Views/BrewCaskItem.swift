//
//  BrewCaskItem.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class BrewCaskItem: NSCollectionViewItem {
	
	typealias Input = BrewCaskItemModelInput
	typealias Output = BrewCaskItemModelOutput
	
	@IBOutlet weak var nameLabel: NSTextField!
	
	private var disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}
	
}

extension BrewCaskItem: NibLoadable, Reusable {}

extension BrewCaskItem: Configurable {
	
	func configure(with model: BrewCaskItemModel) {
//		let input: Input = model
		let output: Output = model
		
		disposeBag = DisposeBag()
		
		output.name
			.bind(to: nameLabel.rx.text)
			.disposed(by: disposeBag)
	}
}
