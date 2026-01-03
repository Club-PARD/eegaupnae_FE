//
//  FileUploadView.swift
//  Shoppingmate_Frontend
//
//  Created by 손채원 on 1/3/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileUploadView: View {
    @Binding var selectedFileURL: URL?
    @State private var isFileImporterPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("증빙서류 제출(Excel, PDF)")
                .font(.system(size: 14))
                .foregroundColor(Color(red:10/255, green: 10/255, blue: 10/255))
                .padding(.top, 10)
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color(red:249/255, green: 250/255, blue: 251/255))
                    .frame(width: 314, height: 116)
                    .overlay(//테두리
                        RoundedRectangle(cornerRadius: 13)
                            .stroke(
                                Color.black.opacity(0.1),
                                lineWidth: 1.8
                            )
                    )
                HStack {
                    Spacer()
                    VStack {
                        Image("uploadIcon")
                            .frame(width: 29, height: 29)
                            .foregroundColor(Color(red:153/255, green: 161/255, blue: 175/255))
                                .padding(1)
                        Text("클릭하여 파일 업로드")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red:106/255, green: 114/255, blue: 130/255))
                        Text("사업자등록증 또는 관련 서류")
                            .font(.system(size: 11))
                            .foregroundColor(Color(red:153/255, green: 161/255, blue: 175/255))
                            .padding(1)
                    }
                    Spacer()
                }
            }//증빙서류 제출 버튼
            .onTapGesture {
                isFileImporterPresented = true
            }
            .fileImporter(
                isPresented: $isFileImporterPresented,
                allowedContentTypes: [.spreadsheet],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result {
                    selectedFileURL = urls.first
                }
            }

            //선택한 파일명 표시
            if let fileURL = selectedFileURL {
                Text(fileURL.lastPathComponent)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
}

//#Preview {
//    FileUploadView()
//}
