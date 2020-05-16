//
//  BrewCaskViewItem.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class BrewCaskViewItem: NSCollectionViewItem {
	
	typealias Input = BrewCaskViewItemModelInput
	typealias Output = BrewCaskViewItemModelOutput
	
	@IBOutlet weak var nameLabel: NSTextField!
	@IBOutlet weak var browseButton: NSButton!
	@IBOutlet weak var downloadButton: NSButton!
	@IBOutlet weak var installButton: NSButton!
	
	private var disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}
	
}

extension BrewCaskViewItem: NibLoadable, Reusable {}

extension BrewCaskViewItem: Configurable {
	
	func configure(with model: BrewCaskViewItemModel) {
		let input: Input = model
		let output: Output = model
		
		disposeBag = DisposeBag()
		
		browseButton.rx.tap
			.bind(to: input.browseClick)
			.disposed(by: disposeBag)
		
		downloadButton.rx.tap
			.bind(to: input.downloadClick)
			.disposed(by: disposeBag)
		
		installButton.rx.tap
			.bind(to: input.installClick)
			.disposed(by: disposeBag)
		
		output.name
			.bind(to: nameLabel.rx.text)
			.disposed(by: disposeBag)
	}
}
