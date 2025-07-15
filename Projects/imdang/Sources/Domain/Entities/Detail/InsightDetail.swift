//
//  InsightDetail.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//

import UIKit

enum DetailExchangeState: String, Codable {
    case pending = "PENDING"
    case rejected = "REJECTED"
    case accepted = "ACCEPTED"
    case null = "NULL"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try? container.decode(String.self)

        self = DetailExchangeState(rawValue: value ?? "NULL") ?? .null
    }
}

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

struct InsightDetail: Codable {
    var memberId: String = UserdefaultKey.memberId
    var memberNickname: String
    var score: Int
    var mainImage: String
    var title: String
    var address: Address
    var apartmentComplex: InsightDTO.ApartmentComplex
    var visitAt: String
    var visitTimes: [String]
    var visitMethods: [String]
    var summary: String
    var access: String
    
    var infra: Infrastructure
    var complexEnvironment: Environment
//    var complexFacility: Facility
//    var favorableNews: FavorableNews
    
    var exchangeRequestStatus: DetailExchangeState = .null
    var exchangeRequestId: String? = ""
    var recommended: Bool
    var exchangeRequestCreatedByMe: Bool? = nil
    var insightId: String
    var accused: Bool
    var accusedCount: Int
    var createdAt: String
    var viewCount: Int
    var recommendedCount: Int
    
    static var emptyInsight: InsightDetail {
        return InsightDetail(
            memberId: UserdefaultKey.memberId,
            memberNickname: "",
            score: 0,
            mainImage: "",
            title: "",
            address: Address(siDo: "", siGunGu: "", eupMyeonDong: "", buildingNumber: "", latitude: 0, longitude: 0),
            apartmentComplex: InsightDTO.ApartmentComplex(name: ""),
            visitAt: "",
            visitTimes: [],
            visitMethods: [],
            summary: "",
            access: "",
            infra: Infrastructure(transportations: [], schoolDistricts: [], amenities: [], facilities: [], surroundings: [], landmarks: [], unpleasantFacilities: [], text: ""),
            complexEnvironment: Environment(buildingCondition: [], security: [], childrenFacility: [], seniorFacility: [], text: ""),
            exchangeRequestStatus: .null,
            exchangeRequestId: nil,
            recommended: false,
            exchangeRequestCreatedByMe: nil,
            insightId: "",
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
            score: self.score,
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
