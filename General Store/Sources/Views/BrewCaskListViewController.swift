//
//  ViewController.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxSwift
import Cocoa
import RxCocoa

class BrewCaskListViewController: NSViewController {
	
	typealias Input = BrewCaskListViewModelInput
	typealias Output = BrewCaskListViewModelOutput
	
	@IBOutlet private weak var collectionView: NSCollectionView!
	
	private let input: Input
	private let output: Output
	private let disposeBag = DisposeBag()
	
	init(viewModel: Input & Output = BrewCaskListViewModel()) {
		self.input = viewModel
		self.output = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		let viewModel = BrewCaskListViewModel()
		self.input = viewModel
		self.output = viewModel
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let itemType = BrewCaskViewItem.self
		collectionView.register(itemType: itemType)
		
		output.items
			.bind(to: collectionView.rx.items(itemType))
			.disposed(by: disposeBag)
	}
}
