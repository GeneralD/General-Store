//
//  FormulaListViewController.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/17.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class FormulaListViewController: NSViewController {
	
	typealias Input = FormulaListViewModelInput
	typealias Output = FormulaListViewModelOutput
	
	@IBOutlet private weak var collectionView: NSCollectionView!
	
	private let input: Input
	private let output: Output
	private let disposeBag = DisposeBag()
	
	init(viewModel: Input & Output = FormulaListViewModel()) {
		self.input = viewModel
		self.output = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		let viewModel = FormulaListViewModel()
		self.input = viewModel
		self.output = viewModel
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let itemType = FormulaItemViewController.self
		collectionView.register(itemType: itemType)
		
		output.items
			.bind(to: collectionView.rx.items(itemType))
			.disposed(by: disposeBag)
	}
}
