//
//  CollectionViewCellFactoryBinder.swift
//  RxCells
//
//  Created by Tomasz Pikć on 08/10/2019.
//

import Cocoa
import RxSwift
//import Reusable

struct CollectionViewCellFactoryBinder<Factory: CollectionViewCellFactory>: ItemBinder {
	let factory: Factory
	
	func bind(to ui: NSCollectionView) -> Binding<Factory.Model> {
		let source = BehaviorSubject(value: [Factory.Model]())
		let binding = source.bind(to: ui.rx.items(using: factory))
		return Binding(observer: source, subscription: binding)
	}
}
