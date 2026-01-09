//
//  String+Extension.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/9/26.
//

import Foundation

extension String {
    var removingDoubleAsterisks: String {
        self.replacingOccurrences(of: "**", with: "")
    }
}
