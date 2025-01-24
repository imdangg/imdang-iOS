//
//  InsightSectionInfo.swift
//  imdang
//
//  Created by 임대진 on 12/31/24.
//

import Foundation

struct InsightSectionInfo {
    let title: String
    let subTitle: String?
    let description: String
    let buttonTitles: [String]
    
    // infrastructure
    static let trafic: InsightSectionInfo = InsightSectionInfo(title: "교통*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "주차 편리", "지하철역 주변", "버스 정류장 주변"])
    static let educationInfo: InsightSectionInfo = InsightSectionInfo(title: "학군*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "초품아", "어린이집", "중학교", "고등학교", "학원가"])
    static let livingFacility: InsightSectionInfo = InsightSectionInfo(title: "생활 편의시설*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "주민센터", "편의점", "소형마트", "대형마트", "병원", "은행", "카페", "미용실", "약국", "우체국"])
    static let culturalAndLeisure: InsightSectionInfo = InsightSectionInfo(title: "문화 및 여가시설 (단지외부)*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "도서관", "영화관", "체육관", "헬스장", "수영장", "배드민턴장", "테니스장", "골프 연습장"])
    static let surroundEnvironment: InsightSectionInfo = InsightSectionInfo(title: "주변환경*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "강", "바다", "산", "공원", "산책로", "교회", "성당", "식당가", "시장"])
    static let landMark: InsightSectionInfo = InsightSectionInfo(title: "랜드마크*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "놀이공원", "복합 쇼핑몰", "고궁", "전망대", "국립공원", "한옥마을", "사찰", "미술관", "박물관"])
    static let repellentFacility: InsightSectionInfo = InsightSectionInfo(title: "기피시설*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "고속도로", "철도", "유흥거리", "산업단지", "공장", "쓰레기 소각장", "고층 건물", "공사중 건물"])
    
    // environment
    static let building: InsightSectionInfo = InsightSectionInfo(title: "건물*", subTitle: "ex. 단지 외관 상태, 엘리베이터, 계단의 청결", description: "하나만 선택", buttonTitles: ["잘 모르겠어요", "최고예요", "좋아요", "평범해요", "별로에요"])
    static let safety: InsightSectionInfo = InsightSectionInfo(title: "안전*", subTitle: "ex. CCTV, 경비원 상주 및 태도, 가로등", description: "하나만 선택", buttonTitles: ["잘 모르겠어요", "최고예요", "좋아요", "평범해요", "별로에요"])
    static let childrenFacility: InsightSectionInfo = InsightSectionInfo(title: "어린이 시설*", subTitle: "ex. 놀이터, 어린이 보호 구역", description: "하나만 선택", buttonTitles: ["잘 모르겠어요", "최고예요", "좋아요", "평범해요", "별로에요"])
    static let seniorFacility: InsightSectionInfo = InsightSectionInfo(title: "경로 시설*", subTitle: nil, description: "하나만 선택", buttonTitles: ["잘 모르겠어요", "최고예요", "좋아요", "평범해요", "별로에요"])
    
    // facility
    static let family: InsightSectionInfo = InsightSectionInfo(title: "가족*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "어린이집", "경로당"])
    static let multipurpose: InsightSectionInfo = InsightSectionInfo(title: "다목적*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "다목적실", "입주자 대표 회의실", "공용 세탁소", "공용 휴게실"])
    static let leisure: InsightSectionInfo = InsightSectionInfo(title: "여가 (단지내부)*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "피트니스 센터", "독서실", "사우나", "목욕탕", "스크린 골프장", "영화관", "도서관", "수영장", "공부방", "어린이집", "게스트하우스", "워터파크", "조식"])
    static let environment: InsightSectionInfo = InsightSectionInfo(title: "환경*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["해당 없음", "잔디밭", "조형물", "벤치", "테이블 및 의자", "분수"])
    
    // favorableNews
    static let traficNews: InsightSectionInfo = InsightSectionInfo(title: "교통*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["잘 모르겠어요", "지하철 개통", "고속철도역 신설", "교통 허브 지정"])
    static let develop: InsightSectionInfo = InsightSectionInfo(title: "개발*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["잘 모르겠어요", "재개발", "재건축", "리모델링", "인근 신도시 개발", "복합 단지 개발", "대형 쇼핑몰", "백화점", "대형 오피스 단지"])
    static let education: InsightSectionInfo = InsightSectionInfo(title: "교육*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["잘 모르겠어요", "초등학교 신설 예정", "고등학교 신설 예정", "특목고", "자사고", "국제학교", "대학 캠퍼스"])
    static let naturalEnvironment: InsightSectionInfo = InsightSectionInfo(title: "자연환경*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["잘 모르겠어요", "대형 공원", "하천 복원", "호수 복원"])
    static let culture: InsightSectionInfo = InsightSectionInfo(title: "문화*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["잘 모르겠어요", "대형 병원", "문화센터", "도서관", "공연장", "체육관"])
    static let industry: InsightSectionInfo = InsightSectionInfo(title: "산업*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["잘 모르겠어요", "산업 단지", "기업 이전", "스타트업 단지"])
    static let policy: InsightSectionInfo = InsightSectionInfo(title: "정책*", subTitle: nil, description: "복수 선택 가능", buttonTitles: ["잘 모르겠어요", "투기 과열 지구 해제", "규제 완화", "특구 지정", "일자리 창출 정책"])
}
