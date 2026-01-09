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
                        if let imageUrl = unwrappedDetail.naverImage {
                            Section {
                                ImageCard(imageUrl: imageUrl)
                                    .listRowInsets(
                                        EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
                                    )
                                    .listRowBackground(Color.clear)
                            }
                            .listSectionSpacing(13)
                        }
//                        Section{
//                            if let imageUrlString = unwrappedDetail.naverImage,
//                               let url = URL(string: imageUrlString) {
//
//                                AsyncImage(url: url) { phase in
//                                    switch phase {
//                                    case .empty:
//                                        ProgressView()
//                                            .frame(height: 360)
//
//                                    case .success(let image):
//                                        image
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(height: 360)
//                                            .frame(maxWidth: .infinity)
//                                            .clipped()
//                                            .clipShape(
//                                                RoundedRectangle(
//                                                    cornerRadius: 12,
//                                                    style: .continuous
//                                                )
//                                            )
//
//                                    case .failure:
//                                        Image(systemName: "photo")
//                                            .frame(height: 360)
//
//                                    @unknown default:
//                                        EmptyView()
//                                    }
//                                }
//                            }
//                            AsyncImage(unwrappedDetail.naverImage)
//                                .resizable()
//                                . listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
//                                .frame(width: 362, height: 360)
//                                .listRowBackground(Color.clear)
//                                .clipShape(
//                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                )
//                        }//section
//                        .listSectionSpacing(13) // 이거 해야 총 18
                        
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


//
//#Preview {
//    NavigationStack {
//        DetailView(
//            scanId: 1,
//            previewDetail: .mock
//        )
//    }
//}


