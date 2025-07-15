//
//  InsightDTO.swift
//  imdang
//
//  Created by 임대진 on 1/22/25.
//

import Foundation

struct InsightDTO: Codable {
    struct Address: Codable {
        let siDo: String
        let siGunGu: String
        let eupMyeonDong: String
        let roadName: String
        let buildingNumber: String
        let detail: String
        let latitude: Double
        let longitude: Double
    }
    
    struct ApartmentComplex: Codable {
        var name: String
    }
    
    struct Infra: Codable {
        let transportations: [String]
        let schoolDistricts: [String]
        let amenities: [String]
        let facilities: [String]
        let surroundings: [String]
        let text: String
    }
    
    struct ComplexEnvironment: Codable {
        let buildingCondition: String
        let security: String
        let childrenFacility: String
        let text: String
    }
    
    var insightId: String? = nil
    let score: Int
    let title: String
    let address: Address
    let apartmentComplex: ApartmentComplex
    let visitAt: String
    let visitTimes: [String]
    let visitMethods: [String]
    let summary: String
    let access: String
    let infra: Infra
    let complexEnvironment: ComplexEnvironment
}
