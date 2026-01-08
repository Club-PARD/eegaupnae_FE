//
//  AnalysisIconProvider.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/9/26.
//

import SwiftUI
import Foundation

enum AnalysisCategory: String {
    case 신선
    case 가공
    case 기호
    case 위생
    case 뷰티
    case 리빙
    case 펫라이프
    
    static func from(serverValue: String) -> AnalysisCategory? {
        let trimmed = serverValue.trimmingCharacters(in: .whitespacesAndNewlines)

        // 서버 표현이 다를 수 있는 케이스 흡수
        switch trimmed {
        case "펫/라이프", "펫 라이프":
            return .펫라이프
        default:
            return AnalysisCategory(rawValue: trimmed)
        }
    }
}

struct AnalysisIconProvider {

    static func icons(for categoryString: String) -> [String] {
        
        guard let category = AnalysisCategory.from(serverValue: categoryString) else {
            return Array(repeating: "icon_default", count: 5)
        }
        
        switch category {
            
        case .신선:
            return [
                "icon_fresh_1",
                "icon_fresh_2",
                "icon_fresh_3",
                "icon_fresh_4",
                "icon_fresh_5"
            ]

        case .가공:
            return [
                "icon_processed_1",
                "icon_processed_2",
                "icon_processed_3",
                "icon_processed_4",
                "icon_processed_5"
            ]

        case .기호:
            return [
                "icon_preference_1",
                "icon_preference_2",
                "icon_preference_3",
                "icon_preference_4",
                "icon_preference_5"
            ]

        case .위생:
            return [
                "icon_hygiene_1",
                "icon_hygiene_2",
                "icon_hygiene_3",
                "icon_hygiene_4",
                "icon_hygiene_5"
            ]

        case .뷰티:
            return [
                "icon_beauty_1",
                "icon_beauty_2",
                "icon_beauty_3",
                "icon_beauty_4",
                "icon_beauty_5"
            ]

        case .리빙:
            return [
                "icon_living_1",
                "icon_living_2",
                "icon_living_3",
                "icon_living_4",
                "icon_living_5"
            ]

        case .펫라이프:
            return [
                "icon_pet_1",
                "icon_pet_2",
                "icon_pet_3",
                "icon_pet_4",
                "icon_pet_5"
            ]
        }
    }
}
