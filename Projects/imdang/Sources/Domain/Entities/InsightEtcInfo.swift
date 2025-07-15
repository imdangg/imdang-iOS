//
//  InsightEtcInfo.swift
//  imdang
//
//  Created by 임대진 on 12/31/24.
//

import Foundation

struct InsightEtcInfo {
    static let infrastructure: [InsightSectionInfo] = [InsightSectionInfo.trafic, InsightSectionInfo.educationInfo, InsightSectionInfo.livingFacility, InsightSectionInfo.culturalAndLeisure, InsightSectionInfo.surroundEnvironment]
    
    static let environment: [InsightSectionInfo] = [InsightSectionInfo.building, InsightSectionInfo.safety, InsightSectionInfo.childrenFacility]
    
    static let facility: [InsightSectionInfo] = [InsightSectionInfo.family, InsightSectionInfo.multipurpose, InsightSectionInfo.leisure, InsightSectionInfo.environment]
    
    static let goodNews: [InsightSectionInfo] = [InsightSectionInfo.traficNews, InsightSectionInfo.develop, InsightSectionInfo.education, InsightSectionInfo.naturalEnvironment, InsightSectionInfo.culture, InsightSectionInfo.industry, InsightSectionInfo.policy]
}
