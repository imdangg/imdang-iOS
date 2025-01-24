//
//  Facility.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct Facility: Codable {
    var familyFacilities: [String]
    var multipurposeFacilities: [String]
    var leisureFacilities: [String]
    var surroundings: [String]
    var text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("가족", familyFacilities),
            ("다목적", multipurposeFacilities),
            ("여가 (단지내부)", leisureFacilities),
            ("환경", surroundings)
        ]
        
        return allArrays
    }
}
