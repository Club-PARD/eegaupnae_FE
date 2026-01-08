//
//  DetailMock.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/6/26.
//

import SwiftUI

struct DetailData: Identifiable {
    let id: String

    // 헤더 이미지
    let headerImageName: String

    // 기본 정보
    let title: String
    let rating: Double
    let reviewCount: Int

    // 가격
    let pickPrice: String
    let martPrice: String
    let onlinePrice: String

    // SALE 배너
    let saleBannerText: String?

    // 섹션
    let analysisBullets: [String]
    let tipBullets: [String]
}

enum MockDetailStore {
    static func detail(for product: RecognizedProduct) -> DetailData {
        // product.id 기준으로 분기하고 싶으면 switch 넣으면 됨
        DetailData(
            id: product.id.uuidString,
            headerImageName: "jh", 
            title: "\(product.name) \(product.amount)",
            rating: 2.5,
            reviewCount: 308,
            pickPrice: "8,480원",
            martPrice: "12,800원",
            onlinePrice: "6,080원",
            saleBannerText: "점심시간! 3일 뒤에 행사가 있어요\n1/9(목)부터 1번 1+1 행사입니다.\n현지점 가격에 도움이 필요하면 눌러주세요!",
            analysisBullets: [
                "실질 사용 후기는 잔향이 오래가고, 세탁 후 실내건조 향이 깔끔하다는 의견이 많아요.",
                "흡수력·퍼짐감은 평균 수준이지만 향 지속력은 높은 편이에요.",
                "화학적 향이 강하다는 리뷰도 있어 민감한 사람은 소량 테스트 추천!"
            ],
            tipBullets: [
                "공식·대형몰 행사 때 가격이 많이 내려가요. 특히 1+1, 2+1 행사 타이밍을 노려보세요.",
                "가격: 1.5L 기준 사용량에 따라 체감 단가가 달라져요. 대용량이 항상 이득은 아니에요.",
                "로컬 구매 팁: 점포별로 가격 차이가 커서 온라인 최저가와 함께 비교하면 좋아요."
            ]
        )
    }
}
