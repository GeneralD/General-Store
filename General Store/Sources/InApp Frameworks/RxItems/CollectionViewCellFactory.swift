//
//  CollectionViewCellFactory.swift
//  RxCells
//
//  Created by Tomasz Pikć on 08/10/2019.
//

import Cocoa

public protocol CollectionViewCellFactory {
	associatedtype Model
	
	func create(collectionView: NSCollectionView, indexPath: IndexPath, model: Model) -> NSCollectionViewItem
}
