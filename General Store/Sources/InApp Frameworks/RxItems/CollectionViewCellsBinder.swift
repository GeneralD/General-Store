//
//  CollectionViewCellsBinder.swift
//  RxCells
//
//  Created by Tomasz Pikć on 08/10/2019.
//

import Cocoa
import RxSwift
//import Reusable

struct CollectionViewCellBinder<Cell: NSCollectionViewItem>: ItemBinder where Cell: Reusable, Cell: Configurable {
	
	func bind(to ui: NSCollectionView) -> Binding<Cell.Model> {
		let source = BehaviorSubject(value: [Cell.Model]())
		let binding = source.bind(to: ui.rx.items(Cell.self))
		return Binding(observer: source, subscription: binding)
	}
}
