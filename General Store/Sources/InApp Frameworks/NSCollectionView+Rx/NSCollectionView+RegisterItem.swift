//
//  NSCollectionView+RegisterItem.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/15.
//  Copyright © 2020 ZYXW. All rights reserved.
//

#if os(OSX)

import Cocoa
import RxSwift

extension NSCollectionView {
	public func register<Cell: NSCollectionViewItem>(cellType: Cell.Type) {
		let identifier = NSUserInterfaceItemIdentifier(.init(describing: cellType))
		let nib = NSNib(nibNamed: .init(describing: cellType), bundle: nil)
		register(nib, forItemWithIdentifier: identifier)
	}
}

extension Reactive where Base: NSCollectionView {
	public func items<Sequence: Swift.Sequence, Cell: NSCollectionViewItem, Source: ObservableType>(cellType: Cell.Type = Cell.self)
		-> (_ source: Source)
		-> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
		-> Disposable where Source.Element == Sequence {
			items(cellIdentifier: .init(rawValue: .init(describing: cellType)), cellType: cellType)
	}
}

#endif
