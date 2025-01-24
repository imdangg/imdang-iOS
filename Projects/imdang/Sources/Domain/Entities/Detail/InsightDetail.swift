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
    var buildingNumber: String
    var detail: String? = ""
    var latitude: Int
    var longitude: Int
    
    func toString() -> String {
        return "\(siDo) \(siGunGu) \(eupMyeonDong)\( roadName ?? "") \(buildingNumber)\( detail ?? "")"
    }
    
    func toShortString() -> String {
        return "\(siGunGu) \(eupMyeonDong)"
    }
}

struct InsightDetail: Codable {
    var memberId: String = UserdefaultKey.memberId
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
    var complexFacility: Facility
    var favorableNews: FavorableNews
    
    var exchangeRequestStatus: String? = ""
    var exchangeRequestId: String? = ""
    func printDetails() {
        print("Member ID: \(memberId)")
        print("Score: \(score)")
        print("Main Image: \(mainImage)")
        print("Title: \(title)")
        print("Address: \(address.toString())")
        print("Apartment Complex: \(apartmentComplex)")
        print("Visit At: \(visitAt)")
        print("Visit Times: \(visitTimes.joined(separator: ", "))")
        print("Visit Methods: \(visitMethods.joined(separator: ", "))")
        print("Summary: \(summary)")
        print("Access: \(access)")
        
        print("Infrastructure: \(infra)")
        print("Complex Environment: \(complexEnvironment)")
        print("Complex Facility: \(complexFacility)")
        print("Favorable News: \(favorableNews)")
    }
    static var testData = InsightDetail(score: 0 , mainImage: "", title: "초역세권 대단지 아파트 후기", address: Address(siDo: "서울특별시", siGunGu: "영등포구", eupMyeonDong: "당산 2동", buildingNumber: "123-456", latitude: 0, longitude: 0), apartmentComplex: InsightDTO.ApartmentComplex(name: "테스트제목"), visitAt: "2024-01-01", visitTimes: ["저녁"], visitMethods: ["자차", "도보"], summary: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요.", access: "자유로움",
                                        infra: Infrastructure(transportations: ["해당 없음"], schoolDistricts: ["초품아", "학원가"], amenities: ["주민센터", "편의점"], facilities: ["도서관", "영화관", "헬스장"], surroundings: ["산", "공원"], landmarks: ["놀이공원", "복합 쇼핑몰", "고궁", "전망대", "국립공원", "한옥마을"], unpleasantFacilities: ["고속도로", "유흥거리"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."),
                                        complexEnvironment: Environment(buildingCondition: ["잘 모르겠어요"], security: ["좋아요"], childrenFacility: ["평범해요"], seniorFacility: ["좋아요"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."),
                                        complexFacility: Facility(familyFacilities: ["어린이집"], multipurposeFacilities: ["해당 없음"], leisureFacilities: ["피트니스 센터", "독서실", "사우나", "목욕탕", "스크린 골프장", " 영화관", "도서관", "수영장"], surroundings: ["잔디밭"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."),
                                        favorableNews: FavorableNews(transportations: ["잘 모르겠어요"], developments: ["재개발", "재건축", "인근 신도시 개발"], educations: ["잘 모르겠어요"], environments: ["하천 복원", "호수 복원"], cultures: ["대형병원", "문화센터", "도서관", "공연장"], industries: ["산업단지"], policies: ["투기 과열 지구 해제", "일자리 창출 정책"], text: "단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다. 다만 주차 공간이 협소하고, 단지 내 보안 카메라 설치가 부족한 점이 아쉬워요. 단지는 전반적으로 관리 상태가 양호했으며, 주변에 대형 마트와 초등학교가 가까워 생활 편의성이 뛰어납니다."))
    
    static var emptyInsight = InsightDetail(score: 0, mainImage: "", title: "", address: Address(siDo: "", siGunGu: "", eupMyeonDong: "", buildingNumber: "", latitude: 0, longitude: 0), apartmentComplex: InsightDTO.ApartmentComplex(name: ""), visitAt: "", visitTimes: [], visitMethods: [], summary: "", access: "", infra: Infrastructure(transportations: [], schoolDistricts: [], amenities: [], facilities: [], surroundings: [], landmarks: [], unpleasantFacilities: [], text: ""), complexEnvironment: Environment(buildingCondition: [""], security: [""], childrenFacility: [""], seniorFacility: [""], text: ""), complexFacility: Facility(familyFacilities: [], multipurposeFacilities: [], leisureFacilities: [], surroundings: [], text: ""), favorableNews: FavorableNews(transportations: [], developments: [], educations: [], environments: [], cultures: [], industries: [], policies: [], text: ""))
}

extension InsightDetail {
    func toDTO() -> InsightDTO {
        return InsightDTO(
            memberId: self.memberId,
            score: self.score,
            title: self.title,
            address: InsightDTO.Address(
                siDo: self.address.siDo,
                siGunGu: self.address.siGunGu,
                eupMyeonDong: self.address.eupMyeonDong,
                roadName: self.address.roadName ?? "",
                buildingNumber: self.address.buildingNumber,
                detail: self.address.detail ?? "",
                latitude: 0.0,
                longitude: 0.0
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
                landmarks: self.infra.landmarks,
                unpleasantFacilities: self.infra.unpleasantFacilities,
                text: self.infra.text
            ),
            complexEnvironment: InsightDTO.ComplexEnvironment(
                buildingCondition: self.complexEnvironment.buildingCondition.first ?? "",
                security: self.complexEnvironment.security.first ?? "",
                childrenFacility: self.complexEnvironment.childrenFacility.first ?? "",
                seniorFacility: self.complexEnvironment.seniorFacility.first ?? "",
                text: self.complexEnvironment.text
            ),
            complexFacility: InsightDTO.ComplexFacility(
                familyFacilities: self.complexFacility.familyFacilities,
                multipurposeFacilities: self.complexFacility.multipurposeFacilities,
                leisureFacilities: self.complexFacility.leisureFacilities,
                surroundings: self.complexFacility.surroundings,
                text: self.complexFacility.text
            ),
            favorableNews: InsightDTO.FavorableNews(
                transportations: self.favorableNews.transportations,
                developments: self.favorableNews.developments,
                educations: self.favorableNews.educations,
                environments: self.favorableNews.environments,
                cultures: self.favorableNews.cultures,
                industries: self.favorableNews.industries,
                policies: self.favorableNews.policies,
                text: self.favorableNews.text
            )
        )
    }
}
