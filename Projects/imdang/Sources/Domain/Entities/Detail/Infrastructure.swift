//
//  Infrastructure.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct Infrastructure: Codable {
    var transportations: [String]
    var schoolDistricts: [String]
    var amenities: [String]
    var facilities: [String]
    var surroundings: [String]
    var landmarks: [String]
    var unpleasantFacilities: [String]
    var text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("교통", transportations),
            ("학군", schoolDistricts),
            ("생활 편의 시설", amenities),
            ("문화 및 여가시설 (단지외부)", facilities),
            ("주변환경", surroundings),
            ("랜드마크", landmarks),
            ("기피 시설", unpleasantFacilities)
        ]
        
        return allArrays
    }
}
