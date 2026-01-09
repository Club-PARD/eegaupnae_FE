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
                        Section {
                            if let imageUrl = unwrappedDetail.naverImage,
                               imageUrl.hasPrefix("http") {

                                ImageCard(imageUrl: imageUrl)
                                    .listRowInsets(
                                        EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
                                    )

                            } else {
                                HStack {
                                    Spacer()
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .foregroundColor(.gray.opacity(0.4))
                                    Spacer()
                                }
                                .listRowInsets(
                                    EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
                                )
                            }
                        }
                        .listSectionSpacing(20)
                        
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
                    //.listStyle(.plain)
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



#Preview {
    NavigationStack {
        DetailView(scanId: 1)
    }
}
