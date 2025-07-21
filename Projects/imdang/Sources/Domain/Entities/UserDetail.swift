//
//  UserDetail.swift
//  imdang
//
//  Created by 임대진 on 2/7/25.
//

import Foundation

struct MeResponse: Codable {
    let data: MeDetail
    let error: ImdangError?
}

struct MeDetail: Codable {
    let nickname: String
    private let rawInsightCount: String?

    var insightCount: Int {
        if rawInsightCount == "null" || rawInsightCount == nil {
            return 0
        } else {
            return Int(rawInsightCount!)!
        }
    }

    enum CodingKeys: String, CodingKey {
        case nickname
        case rawInsightCount = "insightCount"
    }
}

