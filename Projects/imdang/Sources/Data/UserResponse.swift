//
//  UserResponse.swift
//  imdang
//
//  Created by 임대진 on 7/9/25.
//

import Foundation

struct UserResponse: Codable {
    var user: User
    var error: ImdangError?
    
    enum CodingKeys: String, CodingKey {
        case user = "data"
    }
}

