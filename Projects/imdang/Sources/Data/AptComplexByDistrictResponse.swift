//
//  AptComplexByDistrictResponse.swift
//  imdang
//
//  Created by 임대진 on 7/22/25.
//

import Foundation

struct AptComplexByDistrictResponse: Codable {
    let data: [AptComplexByDistrict]
    let error: ImdangError?
}

struct AptComplexByDistrict: Codable {
    let apartmentComplexName: String
    let insightCount: Int
}
