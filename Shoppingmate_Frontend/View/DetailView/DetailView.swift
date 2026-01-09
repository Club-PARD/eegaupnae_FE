//
//  DetailView.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/6/26.

import SwiftUI

struct DetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let scanId: Int
    
    @State private var detail: DetailResponse?
    
    init(scanId: Int, previewDetail: DetailResponse? = nil) {
        self.scanId = scanId
        self._detail = State(initialValue: previewDetail)
    }
    
    var body: some View {
        ZStack{
            Color(red: 0.95, green: 0.95, blue: 0.95)
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing:0) {
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
                            .foregroundColor(Color.black)
                            .font(
                                Font.custom("Pretendard-Bold", size: 20)
                            )
                        Spacer()
                        
                        NavigationLink {
                            CameraOCRView(cameFromMap: true)
                        } label: {
                            Image("cameraBack")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding(.trailing, 10)
                        }
                     
                    }
                }
                Divider()
                
                if let unwrappedDetail = detail {
                    List{
                        Section{
                            if let imageUrlString = unwrappedDetail.naverImage,
                               let url = URL(string: imageUrlString) {

                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(height: 360)

                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 362, height: 360)
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 12,
                                                    style: .continuous
                                                )
                                            )

                                    case .failure:
                                        Image(systemName: "photo")
                                            .frame(height: 360)

                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
//                            AsyncImage(unwrappedDetail.naverImage)
//                                .resizable()
//                                . listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
//                                .frame(width: 362, height: 360)
//                                .listRowBackground(Color.clear)
//                                .clipShape(
//                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                )
                        }
                        .listSectionSpacing(13) // 이거 해야 총 18
                        
                        Section {
                            Maincard(detail: unwrappedDetail)
                                .listRowInsets(EdgeInsets())
                            SaleInfoCard(detail: unwrappedDetail)
                                .listRowSeparator(.hidden)
                        }
                        //구매 추천 or 비추천
                        Section {
                            PurchaseHoldCard(detail: unwrappedDetail)
                        }
                        //품질 및 가격 요약
                        Section {
                            SummaryCard(detail: unwrappedDetail)
                        }
                        //5대 지표 심층 분석
                        Section {
                            AnalysisCard(detail: unwrappedDetail)
                        }
                    }
                    .listSectionSpacing(18)
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                
            } //vstack
        } // zstack all
        .navigationBarHidden(true)
        //비동기 호출
        .task {
            await loadDetail()
        }
    }
    private func loadDetail() async {
        do {
            detail = try await getGemini(scanId: scanId)
        } catch {
            print("❌ detail 로딩 실패:", error)
        }
    }
}

extension DetailResponse {
    static let mock = DetailResponse(
        naverImage: "https://via.placeholder.com/360x360.png",
        naverBrand: "피죤",
        scanName: "피죤 실내건조 섬유유연제 라벤더향",
        category: "세탁/청소",

        pickScore: 4.3,
        reliabilityScore: 4.1,

        scanPrice: 12800,
        naverPrice: 15000,
        priceDiff: -2200,
        isCheaper: true,

        aiUnitPrice: "1회 사용 약 283원",

        indexes: [
            AnalysisIndex(
                name: "가성비",
                reason: "온라인 평균가 대비 약 2,200원 저렴하여 가격 경쟁력이 높습니다."
            ),
            AnalysisIndex(
                name: "향 지속력",
                reason: "실내건조 환경에서도 향이 오래 유지된다는 평가가 많습니다."
            ),
            AnalysisIndex(
                name: "성분 안정성",
                reason: "대체로 무난하지만 민감한 피부에는 주의가 필요합니다."
            ),
            AnalysisIndex(
                name: "사용 편의성",
                reason: "계량이 쉽고 사용 방법이 직관적입니다."
            ),
            AnalysisIndex(
                name: "재구매 의사",
                reason: "다수의 사용자들이 재구매 의사를 보였습니다."
            )
        ],

        qualitySummary: "향 지속력과 사용 편의성에서 높은 점수를 받았으나, 성분에 민감한 소비자는 주의가 필요합니다.",
        priceSummary: "현재 오프라인 가격이 온라인 평균가보다 약 2,200원 저렴합니다.",
        conclusion: "가격 대비 성능이 우수해 일상용 섬유유연제로 구매를 추천합니다."
    )
}

#Preview {
    NavigationStack {
        DetailView(
            scanId: 1,
            previewDetail: .mock
        )
    }
}


