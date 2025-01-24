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
        let landmarks: [String]
        let unpleasantFacilities: [String]
        let text: String
    }
    
    struct ComplexEnvironment: Codable {
        let buildingCondition: String
        let security: String
        let childrenFacility: String
        let seniorFacility: String
        let text: String
    }
    
    struct ComplexFacility: Codable {
        let familyFacilities: [String]
        let multipurposeFacilities: [String]
        let leisureFacilities: [String]
        let surroundings: [String]
        let text: String
    }
    
    struct FavorableNews: Codable {
        let transportations: [String]
        let developments: [String]
        let educations: [String]
        let environments: [String]
        let cultures: [String]
        let industries: [String]
        let policies: [String]
        let text: String
    }
    
    let memberId: String
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
    let complexFacility: ComplexFacility
    let favorableNews: FavorableNews
}
