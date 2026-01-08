//
//  DetailView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/6/26.

import SwiftUI

struct DetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    let product: RecognizedProduct
    private var detail: DetailData {
        MockDetailStore.detail(for: product)
    }
    
    var body: some View {
        ZStack{
            Color(red: 0.95, green: 0.95, blue: 0.95)
                .ignoresSafeArea(edges: .all)
            VStack {
                ZStack {
                    Rectangle()
                        .frame(height: 61)
                        .foregroundColor(.white)
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image("backArrow")
                                .resizable()
                                .frame(width: 20, height: 24)
                                .padding(.leading, 20)
                        }
                        Text("픽스코어")
                            .font(
                                Font.custom("Arial", size: 20)
                                    .weight(.bold)
                            )
                        Spacer()
                    }
                }
                Divider()
                    .padding(.top, -10)
                ScrollView {
                    VStack(spacing: 0) {
                        //Maincard(product: product)
                        VStack {
                            HStack(spacing: 12) {
                                Text(detail.title)
                                    .font(
                                        Font.custom("Arial-BoldMT", size: 24)
                                    )
                                    .foregroundColor(Color(red: 0.1, green: 0.12, blue: 0.16))
                                Spacer()
                            }//상품명
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.95, green: 0.95, blue: 1.0))
                            )
                            .padding(.horizontal, 16)
                            Divider()
                            HStack {
                                Image("sparkles")
                                    .resizable()
                                    .frame(width: 29, height: 27)
                                    //.padding(.leading, 5)
                                    .padding(.trailing, -10)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.45, green: 0.35, blue: 0.95),
                                                Color(red: 0.30, green: 0.75, blue: 0.95)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                   )
                                Text("Ai 픽스코어")
                                  .font(.custom("Pretendard-Bold", size: 17))
                                  .foregroundStyle(
                                          LinearGradient(
                                              colors: [
                                                  Color(red: 0.65, green: 0.32, blue: 0.91),
                                                  Color(red: 0.19, green: 0.53, blue: 1)
                                              ],
                                              startPoint: .leading,
                                              endPoint: .trailing
                                          )
                                      )
                                StarRatingView(rating: detail.rating)
                                Text(String(format: "%.1f", detail.rating))
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }//hstack
                            HStack {
                                Text("마트 판매가")
                                  .font(.custom("Pretendard-Bold", size: 10))
                                  .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                                Spacer()
                                Text(detail.martPrice)
                                    .font(.custom("Pretendard-Bold", size: 18))
                                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                                    .padding(.leading, 5)
                                    .padding(.bottom, 2)
                            }
                            HStack {
                                Text("온라인 최저가")
                                    .font(.custom("Pretendard-Bold", size: 10))
                                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                                Spacer()
                                Text(detail.onlinePrice)
                                    .font(.custom("Pretendard-Bold", size: 18))
                                    .foregroundColor(Color(red: 0.06, green: 0.09, blue: 0.16))
                                    .padding(.leading, 5)
                                    .padding(.bottom, 2)
                            }
                        }//vstack
                        // ✅ 상단 이미지 + 우측 상단 픽가격 배지
//                        ZStack(alignment: .topTrailing) {
//                            Image(detail.headerImageName)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(height: 220)
//                                .frame(maxWidth: .infinity)
//                                .clipped()
//                            
//                            Text(detail.pickPrice)
//                                .font(.system(size: 28, weight: .bold))
//                                .foregroundStyle(.red)
//                                .padding(.horizontal, 12)
//                                .padding(.vertical, 8)
//                                .background(.white.opacity(0.92))
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .padding(12)
//                        }
//                        .padding(.horizontal, 35)
//                        
//                        VStack(alignment: .leading, spacing: 14) {

//                            
//                            // ✅ SALE 배너
//                            if let banner = detail.saleBannerText, !banner.isEmpty {
//                                HStack(alignment: .top, spacing: 10) {
//                                    Text("SALE")
//                                        .font(.system(size: 12, weight: .bold))
//                                        .foregroundStyle(.white)
//                                        .padding(.horizontal, 10)
//                                        .padding(.vertical, 6)
//                                        .background(Color.red)
//                                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                                    
//                                    Text(banner)
//                                        .font(.system(size: 13, weight: .semibold))
//                                        .foregroundStyle(.white)
//                                        .fixedSize(horizontal: false, vertical: true)
//                                    
//                                    Spacer(minLength: 0)
//                                }
//                                .padding(14)
//                                .background(Color.red.opacity(0.85))
//                                .clipShape(RoundedRectangle(cornerRadius: 14))
//                            }
//                            
//                            // ✅ 분석 섹션 (불릿)
//                            InfoCard(title: "✔️ 평가 및 상품 분석") {
//                                BulletList(items: detail.analysisBullets)
//                            }
//                            
//                            // ✅ 구매 팁 섹션 (번호)
//                            InfoCard(title: "✔️ 구매 팁 & 관련 정보") {
//                                NumberedList(items: detail.tipBullets)
//                            }
//                            
//                            Spacer(minLength: 18)
//                        }
//                        .padding(.horizontal, 16)
//                        .padding(.top, 14)
//                        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                    }
                }//scrollview
                .padding(.top, -17)
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
            }//vstack
        }
    }
}

