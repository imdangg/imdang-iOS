//
//  Environment.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import Foundation

struct Environment: Codable {
    var buildingCondition: [String]
    var security: [String]
    var childrenFacility: [String]
    var seniorFacility: [String]
    var text: String
    
    func conversionArray() -> [(String, [String])] {
        let allArrays: [(name: String, items: [String])] = [
            ("건물", buildingCondition),
            ("안전", security),
            ("어린이 시설", childrenFacility),
            ("경로 시설", seniorFacility)
        ]
        
        return allArrays
    }
}

extension Environment {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        buildingCondition = try container.decodeStringOrArray(forKey: .buildingCondition)
        security = try container.decodeStringOrArray(forKey: .security)
        childrenFacility = try container.decodeStringOrArray(forKey: .childrenFacility)
        seniorFacility = try container.decodeStringOrArray(forKey: .seniorFacility)
        text = try container.decode(String.self, forKey: .text)
    }
}

private extension KeyedDecodingContainer {
    func decodeStringOrArray(forKey key: Key) throws -> [String] {
        if let stringValue = try? decode(String.self, forKey: key) {
            return [stringValue]
        } else if let arrayValue = try? decode([String].self, forKey: key) {
            return arrayValue
        } else {
            return []
        }
    }
}
