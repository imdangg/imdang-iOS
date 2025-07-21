//
//  InsightDetailResponse.swift
//  imdang
//
//  Created by 임대진 on 2/2/25.
//

import Foundation

struct InsightDetailResponse: Codable {
    var data: InsightDetailData
    let error: ImdangError?
}

struct InsightDetailData: Codable {
    var memberId: MemberId = MemberId(value: UserdefaultKey.memberId)
    var memberNickname: String
    var score: Int?
    var images: [String]?
    var title: String
    var address: Address
    var apartmentComplex: InsightDTO.ApartmentComplex
    var visitAt: String
    var visitTimes: [String]
    var visitMethods: [String]
    var summary: String
    var access: String
    var createdByMe: Bool

    var infra: Infrastructure?
    var complexEnvironment: Environment?
    var complexFacility: Facility?
    var favorableNews: FavorableNews?

    var exchangeRequestId: String? = ""
    var recommended: Bool?
    var exchangeRequestCreatedByMe: Bool? = nil
    var insightId: InsightId
    var accused: Bool?
    var accusedCount: Int?
    var createdAt: String?
    var viewCount: Int?
    var recommendedCount: Int
}

extension InsightDetailResponse {
    func toDetail() -> InsightDetail {
        return InsightDetail(
            memberId: self.data.memberId,
            memberNickname: self.data.memberNickname,
            images: self.data.images ?? [""],
            title: self.data.title,
            address: self.data.address,
            apartmentComplex: self.data.apartmentComplex,
            visitAt: self.data.visitAt,
            visitTimes: self.data.visitTimes,
            visitMethods: self.data.visitMethods,
            summary: self.data.summary,
            access: self.data.access,
            createdByMe: self.data.createdByMe,
            infra: self.data.infra ?? Infrastructure(transportations: [""], schoolDistricts: [""], amenities: [""], facilities: [""], surroundings: [""], text: ""),
            complexEnvironment: self.data.complexEnvironment ?? Environment(buildingCondition: [""], security: [""], childrenFacility: [""], text: ""),
            exchangeRequestId: self.data.exchangeRequestId,
            recommended: self.data.recommended ?? false,
            exchangeRequestCreatedByMe: self.data.exchangeRequestCreatedByMe,
            insightId: self.data.insightId,
            accused: self.data.accused ?? false,
            accusedCount: self.data.accusedCount ?? 0,
            createdAt: self.data.createdAt ?? "",
            viewCount: self.data.viewCount ?? 0,
            recommendedCount: self.data.recommendedCount
        )
    }
}
