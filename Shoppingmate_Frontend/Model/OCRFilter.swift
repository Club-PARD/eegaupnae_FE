//
//  OCRText.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/7/26.
//

import Foundation

struct OCRFilter: Identifiable, Codable {
    let id = UUID()
    let name: String
    let price: Int
    let rawText: String
}
