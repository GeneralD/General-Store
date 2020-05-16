//
//  CollectionViewCellWithDelegateFactory.swift
//  RxCells
//
//  Created by Tomasz Pikć on 03/01/2020.
//

import Cocoa
//import Reusable

struct CollectionViewCellWithDelegateFactory<Cell: NSCollectionViewItem>: CollectionViewCellFactory where Cell: HasDelegate & Reusable & Configurable {
	
	let delegate: Cell.Delegate
	
	func create(collectionView: NSCollectionView, indexPath: IndexPath, model: Cell.Model) -> NSCollectionViewItem {
		let cell: Cell = collectionView.dequeueReusableCell(for: indexPath)
		cell.delegate = delegate
		cell.configure(with: model)
		return cell
	}
}
