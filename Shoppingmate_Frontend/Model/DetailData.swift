//
//  DetailMock.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/6/26.
//

import SwiftUI

struct AnalysisIndex: Codable, Identifiable {
    let id = UUID()
    let name: String
    let reason: String
}

struct DetailResponse: Codable {
    let naverImage: String?
    let naverBrand: String?
    let scanName: String
    let category: String

    let pickScore: Double
    let reliabilityScore: Double

    let scanPrice: Double
    let naverPrice: Double
    let priceDiff: Double
    let isCheaper: Bool

    let aiUnitPrice: String?

    let indexes: [AnalysisIndex]

    let qualityState: Bool
    let qualitySummary: String
    let priceState: Bool
    let priceSummary: String
    let conclusion: String
}

struct GeminiDetailResponse: Codable {
    let pickScore: Double
    let reliabilityScore: Double

    let aiUnitPrice: String?
    let indexes: [AnalysisIndex]

    let qualityState: Bool
    let qualitySummary: String
    let priceState: Bool
    let priceSummary: String
    let conclusion: String
}


//extension AnalysisIndex {
//    static let modeling: [AnalysisIndex] = [
//        AnalysisIndex(name: "Hana", reason: "WINGO통장"),
//        AnalysisIndex(name: "bank2", reason: "토스뱅크통장"),
//        AnalysisIndex(name: "bank3", reason: "토스뱅크에 쌓인 이자"),
//        AnalysisIndex(name: "bank4", reason: "MY입출금통장"),
//        AnalysisIndex(name: "bank5", reason: "KB나라사랑우대통장"),
//        ]
//}
