//
//  Token.swift
//  imdang
//
//  Created by 임대진 on 7/17/25.
//

import Foundation

struct Token: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Double?
}
