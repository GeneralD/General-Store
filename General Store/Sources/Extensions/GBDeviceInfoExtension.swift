//
//  GBDeviceInfoExtension.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/19.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GBDeviceInfo

extension GBDeviceInfo {
	var osName: String? {
		guard osVersion.major == 10 else { return nil }
		switch osVersion.minor {
		case 9:
			return "mavericks"
		case 10:
			return "yosemite"
		case 11:
			return "el_capitan"
		case 12:
			return "sierra"
		case 13:
			return "high_sierra"
		case 14:
			return "mojave"
		case 15:
			return "catalina"
		case 16:
			return "big_sur"
		default:
			return nil
		}
	}
}
