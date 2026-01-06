//
//  DetailView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/6/26.

import SwiftUI

struct DetailView: View {
    let product: RecognizedProduct
    
    private var detail: DetailData {
        MockDetailStore.detail(for: product)
    }
    
    var body: some View {
        ZStack{
            Color(red: 0.98, green: 0.98, blue: 0.98)
                .ignoresSafeArea(edges: .all)
        ScrollView {
            VStack(spacing: 0) {
                
                // ✅ 상단 이미지 + 우측 상단 픽가격 배지
                ZStack(alignment: .topTrailing) {
                    Image(detail.headerImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    
                    Text(detail.pickPrice)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.92))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(12)
                }
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    // ✅ 상품명 + 평점
                    VStack(alignment: .leading, spacing: 6) {
                        Text(detail.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.black)
                        
                        HStack(spacing: 6) {
                            StarRatingView(rating: detail.rating)
                            Text(String(format: "%.1f", detail.rating))
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.secondary)
                            Text("(\(detail.reviewCount))")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                    
                    Divider()
                    
                    // ✅ 가격 비교 카드
                    VStack(alignment: .leading, spacing: 10) {
                        PriceRow(title: "📍 픽 제품 가격 (Pick Price)", price: detail.pickPrice, isEmphasis: true)
                        PriceRow(title: "마트 판매가", price: detail.martPrice, isEmphasis: false)
                        PriceRow(title: "온라인가", price: detail.onlinePrice, isEmphasis: false)
                    }
                    .padding(14)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                    
                    // ✅ SALE 배너
                    if let banner = detail.saleBannerText, !banner.isEmpty {
                        HStack(alignment: .top, spacing: 10) {
                            Text("SALE")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            Text(banner)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer(minLength: 0)
                        }
                        .padding(14)
                        .background(Color.red.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    // ✅ 분석 섹션 (불릿)
                    InfoCard(title: "✔️ 평가 및 상품 분석") {
                        BulletList(items: detail.analysisBullets)
                    }
                    
                    // ✅ 구매 팁 섹션 (번호)
                    InfoCard(title: "✔️ 구매 팁 & 관련 정보") {
                        NumberedList(items: detail.tipBullets)
                    }
                    
                    Spacer(minLength: 18)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .background(Color(red: 0.98, green: 0.98, blue: 0.98))
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .navigationTitle("상품 상세")
        .navigationBarTitleDisplayMode(.inline)
    }
}
}
