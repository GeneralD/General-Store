//
//  NSCollectionView+Rx.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/15.
//  Copyright © 2020 ZYXW. All rights reserved.
//

#if os(OSX)

import RxSwift
import RxCocoa
import Cocoa

// Items
extension Reactive where Base: NSCollectionView {
	
	public func items<Sequence: Swift.Sequence, Source: ObservableType>(_ source: Source)
		-> (_ cellFactory: @escaping (NSCollectionView, Int, Sequence.Element) -> NSCollectionViewItem)
		-> Disposable where Source.Element == Sequence {
			return { cellFactory in
				let dataSource = RxCollectionViewReactiveArrayDataSourceSequenceWrapper<Sequence>(cellFactory: cellFactory)
				return self.items(dataSource: dataSource)(source)
			}
			
	}
	
	public func items<Sequence: Swift.Sequence, Cell: NSCollectionViewItem, Source: ObservableType>(cellIdentifier: NSUserInterfaceItemIdentifier, cellType: Cell.Type = Cell.self)
		-> (_ source: Source)
		-> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
		-> Disposable where Source.Element == Sequence {
			return { source in
				return { configureCell in
					let dataSource = RxCollectionViewReactiveArrayDataSourceSequenceWrapper<Sequence> { cv, i, item in
						let indexPath = IndexPath(item: i, section: 0)
						let cell = cv.makeItem(withIdentifier: cellIdentifier, for: indexPath) as! Cell
						configureCell(i, item, cell)
						return cell
					}
					
					return self.items(dataSource: dataSource)(source)
				}
			}
	}
	
	public func items<
		DataSource: RxCollectionViewDataSourceType & NSCollectionViewDataSource, Source: ObservableType>(dataSource: DataSource)
		-> (_ source: Source)
		-> Disposable where DataSource.Element == Source.Element {
			return { source in
				// This is called for sideeffects only, and to make sure delegate proxy is in place when
				// data source is being bound.
				// This is needed because theoretically the data source subscription itself might
				// call `self.rx.delegate`. If that happens, it might cause weird side effects since
				// setting data source will set delegate, and NSCollectionView might get into a weird state.
				// Therefore it's better to set delegate proxy first, just to be sure.
				//			_ = self.delegate
				// Strong reference is needed because data source is in use until result subscription is disposed
				return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource, retainDataSource: true) { [weak collectionView = self.base] (_: RxCollectionViewDataSourceProxy, event) -> Void in
					guard let collectionView = collectionView else {
						return
					}
					dataSource.collectionView(collectionView, observedEvent: event)
				}
			}
	}
}

//
//extension Reactive where Base: NSCollectionView {
//	public typealias DisplayCollectionViewCellEvent = (cell: NSCollectionViewItem, at: IndexPath)
//	
//	/// Reactive wrapper for `dataSource`.
//	///
//	/// For more information take a look at `DelegateProxyType` protocol documentation.
//	public var dataSource: DelegateProxy<NSCollectionView, NSCollectionViewDataSource> {
//		return RxCollectionViewDataSourceProxy.proxy(for: base)
//	}
//	
//	/// Installs data source as forwarding delegate on `rx.dataSource`.
//	/// Data source won't be retained.
//	///
//	/// It enables using normal delegate mechanism with reactive delegate mechanism.
//	///
//	/// - parameter dataSource: Data source object.
//	/// - returns: Disposable object that can be used to unbind the data source.
//	public func setDataSource(_ dataSource: NSCollectionViewDataSource)
//		-> Disposable {
//			return RxCollectionViewDataSourceProxy.installForwardDelegate(dataSource, retainDelegate: false, onProxyForObject: self.base)
//	}
//	
//	/// Reactive wrapper for `delegate` message `collectionView(_:didSelectItemAtIndexPath:)`.
//	public var itemSelected: ControlEvent<IndexPath> {
//		let o = base.delegate as AnyObject
//		o.rx
//		let source = delegate.methodInvoked(#selector(NSCollectionViewDelegate.collectionView(_:didSelectItemAt:)))
//			.map { a in
//				return try castOrThrow(IndexPath.self, a[1])
//		}
//		
//		return ControlEvent(events: source)
//	}
//	
//	/// Reactive wrapper for `delegate` message `collectionView(_:didDeselectItemAtIndexPath:)`.
//	public var itemDeselected: ControlEvent<IndexPath> {
//		let source = delegate.methodInvoked(#selector(NSCollectionViewDelegate.collectionView(_:didDeselectItemAt:)))
//			.map { a in
//				return try castOrThrow(IndexPath.self, a[1])
//		}
//		
//		return ControlEvent(events: source)
//	}
//	
//	/// Reactive wrapper for `delegate` message `collectionView(_:didHighlightItemAt:)`.
//	public var itemHighlighted: ControlEvent<IndexPath> {
//		let source = delegate.methodInvoked(#selector(NSCollectionViewDelegate.collectionView(_:didHighlightItemAt:)))
//			.map { a in
//				return try castOrThrow(IndexPath.self, a[1])
//		}
//		
//		return ControlEvent(events: source)
//	}
//	
//	/// Reactive wrapper for `delegate` message `collectionView(_:didUnhighlightItemAt:)`.
//	public var itemUnhighlighted: ControlEvent<IndexPath> {
//		let source = delegate.methodInvoked(#selector(NSCollectionViewDelegate.collectionView(_:didUnhighlightItemAt:)))
//			.map { a in
//				return try castOrThrow(IndexPath.self, a[1])
//		}
//		
//		return ControlEvent(events: source)
//	}
//	
//	/// Reactive wrapper for `delegate` message `collectionView:willDisplay:forItemAt:`.
//	public var willDisplayCell: ControlEvent<DisplayCollectionViewCellEvent> {
//		let source: Observable<DisplayCollectionViewCellEvent> = self.delegate.methodInvoked(#selector(NSCollectionViewDelegate.collectionView(_:willDisplay:forItemAt:)))
//			.map { a in
//				return (try castOrThrow(NSCollectionViewItem.self, a[1]), try castOrThrow(IndexPath.self, a[2]))
//		}
//		
//		return ControlEvent(events: source)
//	}
//	
//	/// Reactive wrapper for `delegate` message `collectionView:didEndDisplaying:forItemAt:`.
//	public var didEndDisplayingCell: ControlEvent<DisplayCollectionViewCellEvent> {
//		let source: Observable<DisplayCollectionViewCellEvent> = self.delegate.methodInvoked(#selector(NSCollectionViewDelegate.collectionView(_:didEndDisplaying:forItemAt:)))
//			.map { a in
//				return (try castOrThrow(NSCollectionViewItem.self, a[1]), try castOrThrow(IndexPath.self, a[2]))
//		}
//		
//		return ControlEvent(events: source)
//	}
//	
//	/// Reactive wrapper for `delegate` message `collectionView(_:didSelectItemAtIndexPath:)`.
//	///
//	/// It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
//	/// or any other data source conforming to `SectionedViewDataSourceType` protocol.
//	///
//	/// ```
//	///     collectionView.rx.modelSelected(MyModel.self)
//	///        .map { ...
//	/// ```
//	public func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
//		let source: Observable<T> = itemSelected.flatMap { [weak view = self.base as NSCollectionView] indexPath -> Observable<T> in
//			guard let view = view else {
//				return Observable.empty()
//			}
//			
//			return Observable.just(try view.rx.model(at: indexPath))
//		}
//		
//		return ControlEvent(events: source)
//	}
//	
//	/// Reactive wrapper for `delegate` message `collectionView(_:didSelectItemAtIndexPath:)`.
//	///
//	/// It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
//	/// or any other data source conforming to `SectionedViewDataSourceType` protocol.
//	///
//	/// ```
//	///     collectionView.rx.modelDeselected(MyModel.self)
//	///        .map { ...
//	/// ```
//	public func modelDeselected<T>(_ modelType: T.Type) -> ControlEvent<T> {
//		let source: Observable<T> = itemDeselected.flatMap { [weak view = self.base as NSCollectionView] indexPath -> Observable<T> in
//			guard let view = view else {
//				return Observable.empty()
//			}
//			
//			return Observable.just(try view.rx.model(at: indexPath))
//		}
//		
//		return ControlEvent(events: source)
//	}
//	
//	/// Synchronous helper method for retrieving a model at indexPath through a reactive data source
//	public func model<T>(at indexPath: IndexPath) throws -> T {
//		let dataSource: SectionedViewDataSourceType = castOrFatalError(self.dataSource.forwardToDelegate(), message: "This method only works in case one of the `rx.itemsWith*` methods was used.")
//		
//		let element = try dataSource.model(at: indexPath)
//		
//		return try castOrThrow(T.self, element)
//	}
//}

#endif