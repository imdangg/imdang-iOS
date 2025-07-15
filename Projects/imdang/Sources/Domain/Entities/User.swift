//
//  User.swift
//  imdang
//
//  Created by 임대진 on 1/15/25.
//

import Foundation

struct User: Codable {
    let accessToken: String
    let refreshToken: String
    let memberId: String
    let isJoined: Bool
}
