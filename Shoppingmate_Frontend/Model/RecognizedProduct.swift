//
//  RecognizedProduct.swift
//  Shoppingmate_Frontend
//
//  Created by Jinsoo Park on 1/1/26.
//

//
import UIKit

struct RecognizedProduct: Identifiable {
    let id : UUID
    let image: UIImage? //ROI 이미지
    let badge: String?    //"Best 가성비"
    let brand: String         //"피죤"
    let name: String         //"피죤 실내건조 섬유유연제 라벤더향"
    let amount: String      //"2.5L"
    let price: String     //"12,800원"
    let perUse: String    //"1회당 40원"
    
    init( //구조체가 그려질 때 한 번만 저장
        id: UUID = UUID(),
        image: UIImage? = nil,
        badge: String? = nil,
        brand: String,
        name: String,
        amount: String,
        price: String,
        perUse: String
    ) {
        self.id = id
        self.image = image
        self.badge = badge
        self.brand = brand
        self.name = name
        self.amount = amount
        self.price = price
        self.perUse = perUse
    }
}
