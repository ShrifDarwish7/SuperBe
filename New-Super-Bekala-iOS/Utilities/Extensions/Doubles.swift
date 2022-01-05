//
//  Doubles.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 28/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
