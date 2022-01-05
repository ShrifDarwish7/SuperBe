//
//  AppVersion.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 29/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
