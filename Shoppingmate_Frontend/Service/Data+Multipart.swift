//
//  Data+Multipart.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/3/26.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
