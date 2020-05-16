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

/*
{
  "token": "swiftpm-catalog",
  "name": [
	"SwiftPM Catalog"
  ],
  "homepage": "https://zeezide.com/en/products/swiftpmcatalog/",
  "url": "https://zeezide.com/download/SwiftPM%20Catalog.app-1.0.3-14.zip",
  "appcast": "https://zeezide.com/en/products/swiftpmcatalog/",
  "version": "1.0.3-14",
  "sha256": "5cdb2639fa3ac906312b2b6004f4fab9acfcab9c62edb2a260565f7bde0cee21",
  "artifacts": [
	[
	  "SwiftPM Catalog.app"
	]
  ],
  "caveats": null,
  "depends_on": {
	"macos": {
	  ">=": [
		"10.14"
	  ]
	}
  },
  "conflicts_with": null,
  "container": null,
  "auto_updates": null
}
*/
class BrewCaskItem: NSCollectionViewItem {
	
	typealias Input = BrewCaskItemModelInput
	typealias Output = BrewCaskItemModelOutput
	
	private let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do view setup here.
	}
	
}

extension BrewCaskItem: NibLoadable, Reusable {}

extension BrewCaskItem: Configurable {
	
	func configure(with model: BrewCaskItemModel) {
		
	}
}
