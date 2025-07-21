//
//  ApartmentComplexResponse.swift
//  imdang
//
//  Created by 임대진 on 2/7/25.
//

import Foundation

struct ApartmentComplexResponse: Codable {
    let data: [ApartName]
    let error: ImdangError?
}

struct ApartName: Codable {
    var name: String
}
