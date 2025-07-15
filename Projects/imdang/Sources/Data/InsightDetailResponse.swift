//
//  InsightDetailResponse.swift
//  imdang
//
//  Created by 임대진 on 2/2/25.
//

import Foundation

struct InsightDetailResponse: Codable {
    var memberId: String = UserdefaultKey.memberId
    var memberNickname: String
    var score: Int?
    var mainImage: String?
    var title: String
    var address: Address
    var apartmentComplex: InsightDTO.ApartmentComplex
    var visitAt: String
    var visitTimes: [String]
    var visitMethods: [String]
    var summary: String
    var access: String
    
    var infra: Infrastructure?
    var complexEnvironment: Environment?
    var complexFacility: Facility?
    var favorableNews: FavorableNews?
    
    var exchangeRequestStatus: DetailExchangeState = .null
    var exchangeRequestId: String? = ""
    var recommended: Bool?
    var exchangeRequestCreatedByMe: Bool? = nil
    var insightId: String
    var accused: Bool?
    var accusedCount: Int?
    var createdAt: String?
    var viewCount: Int?
    var recommendedCount: Int
}

extension InsightDetailResponse {
    func toDetail() -> InsightDetail {
        return InsightDetail(
            memberId: self.memberId,
            memberNickname: self.memberNickname,
            score: self.score ?? 0,
            mainImage: self.mainImage ?? "",
            title: self.title,
            address: self.address,
            apartmentComplex: self.apartmentComplex,
            visitAt: self.visitAt,
            visitTimes: self.visitTimes,
            visitMethods: self.visitMethods,
            summary: self.summary,
            access: self.access,
            infra: self.infra ?? Infrastructure(transportations: [], schoolDistricts: [], amenities: [], facilities: [], surroundings: [], landmarks: [], unpleasantFacilities: [], text: ""),
            complexEnvironment: self.complexEnvironment ?? Environment(buildingCondition: [""], security: [""], childrenFacility: [""], seniorFacility: [""], text: ""),
            exchangeRequestStatus: self.exchangeRequestStatus,
            exchangeRequestId: self.exchangeRequestId,
            recommended: self.recommended ?? false,
            exchangeRequestCreatedByMe: self.exchangeRequestCreatedByMe,
            insightId: self.insightId,
            accused: self.accused ?? false,
            accusedCount: self.accusedCount ?? 0,
            createdAt: self.createdAt ?? "",
            viewCount: self.viewCount ?? 0,
            recommendedCount: self.recommendedCount
        )
    }
}
