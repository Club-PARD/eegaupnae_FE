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

//struct HardcodedSavingInfo {
//    let savingAmount: Int
//}
//
//let hardcodedSavingMap: [String: HardcodedSavingInfo] = [
//    "샤프란 2.6L 릴렉싱 아로마(리필)": HardcodedSavingInfo(savingAmount: 610),
//    "오뚜기 씻어나온 오뚜기 쌀 1kg": HardcodedSavingInfo(savingAmount: 1290),
//    "맥스웰 커피믹스 오리지널 50T": HardcodedSavingInfo(savingAmount: 890),
//    "오뚜기 진라면 매운맛 5입": HardcodedSavingInfo(savingAmount: 1060),
//    "부자되는 집 내추럴 클래식 화장지 30롤": HardcodedSavingInfo(savingAmount: 1600),
//    "피죤 섬유유연제 퍼플라벤더 1600ml 리필": HardcodedSavingInfo(savingAmount: 310),
//    "스파클 생수 무라벨, 500ml 20개": HardcodedSavingInfo(savingAmount: 800)
//]
//
//extension DetailResponse {
//
//    var hardcodedSavingText: String? {
//        for (key, value) in hardcodedSavingMap {
//            if scanName.contains(key) {
//                return "\(value.savingAmount)원 더 이득"
//            }
//        }
//        return nil
//    }
//
//    /// 뷰에서 최종으로 쓰는 값
//    var savingText: String {
//        if let hardcoded = hardcodedSavingText {
//            return hardcoded
//        }
//
//        // fallback (나중에 서버 붙을 때 대비)
//        return isCheaper
//            ? "\(Int(naverPrice - scanPrice))원 더 이득"
//            : "\(Int(scanPrice - naverPrice))원 더 이득"
//    }
//}

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
