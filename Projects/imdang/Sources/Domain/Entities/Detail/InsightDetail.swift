//
//  InsightDetail.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import UIKit

struct Address: Codable {
    var siDo: String
    var siGunGu: String
    var eupMyeonDong: String
    var roadName: String? = ""
    var buildingNumber: String?
    var detail: String? = ""
    var latitude: Double?
    var longitude: Double?
    
    func toString() -> String {
        return "\(siDo) \(siGunGu) \(eupMyeonDong) \(buildingNumber ?? "")\( detail ?? "")"
    }
    
    func toShortString() -> String {
        return "\(siGunGu) \(eupMyeonDong)"
    }
}

struct MemberId: Codable {
    var value: String
}

struct InsightDetail: Codable {
    var memberId: MemberId = MemberId(value: UserdefaultKey.memberId)
    var memberNickname: String
    var images: [String]
    var title: String
    var address: Address
    var apartmentComplex: InsightDTO.ApartmentComplex
    var visitAt: String
    var visitTimes: [String]
    var visitMethods: [String]
    var summary: String
    var access: String
    var createdByMe: Bool
    
    var infra: Infrastructure
    var complexEnvironment: Environment
    var exchangeRequestId: String? = ""
    var recommended: Bool
    var exchangeRequestCreatedByMe: Bool? = nil
    var insightId: InsightId
    var accused: Bool
    var accusedCount: Int
    var createdAt: String
    var viewCount: Int
    var recommendedCount: Int
    
    static var emptyInsight: InsightDetail {
        return InsightDetail(
            memberId: MemberId(value: UserdefaultKey.memberId),
            memberNickname: "",
            images: [""],
            title: "",
            address: Address(siDo: "", siGunGu: "", eupMyeonDong: "", buildingNumber: "", latitude: 0, longitude: 0),
            apartmentComplex: InsightDTO.ApartmentComplex(name: ""),
            visitAt: "",
            visitTimes: [],
            visitMethods: [],
            summary: "",
            access: "",
            createdByMe: true,
            infra: Infrastructure(transportations: [], schoolDistricts: [], amenities: [], facilities: [], surroundings: [], text: ""),
            complexEnvironment: Environment(buildingCondition: [], security: [], childrenFacility: [], text: ""),
            exchangeRequestId: nil,
            recommended: false,
            exchangeRequestCreatedByMe: nil,
            insightId: InsightId(value: ""),
            accused: false,
            accusedCount: 0,
            createdAt: "",
            viewCount: 0,
            recommendedCount: 0
        )
    }
}

extension InsightDetail {
    func toDTO() -> InsightDTO {
        return InsightDTO(
            title: self.title,
            address: InsightDTO.Address(
                siDo: self.address.siDo,
                siGunGu: self.address.siGunGu,
                eupMyeonDong: self.address.eupMyeonDong,
                roadName: self.address.roadName ?? "",
                buildingNumber: self.address.buildingNumber ?? "",
                detail: self.address.detail ?? "",
                latitude: self.address.latitude ?? 0,
                longitude: self.address.longitude ?? 0
            ),
            apartmentComplex: self.apartmentComplex,
            visitAt: self.visitAt.replacingOccurrences(of: ".", with: "-"),
            visitTimes: self.visitTimes,
            visitMethods: self.visitMethods,
            summary: self.summary,
            access: self.access,
            infra: InsightDTO.Infra(
                transportations: self.infra.transportations,
                schoolDistricts: self.infra.schoolDistricts,
                amenities: self.infra.amenities,
                facilities: self.infra.facilities,
                surroundings: self.infra.surroundings,
                text: self.infra.text
            ),
            complexEnvironment: InsightDTO.ComplexEnvironment(
                buildingCondition: self.complexEnvironment.buildingCondition.first ?? "",
                security: self.complexEnvironment.security.first ?? "",
                childrenFacility: self.complexEnvironment.childrenFacility.first ?? "",
                text: self.complexEnvironment.text
            )
        )
    }
}
