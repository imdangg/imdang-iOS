//
//  TokenResponse.swift
//  imdang
//
//  Created by 임대진 on 7/17/25.
//

import Foundation

struct TokenResponse: Codable {
    let data: Token
    let error: ImdangError?
}
