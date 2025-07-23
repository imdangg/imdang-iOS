//
//  Pageable.swift
//  imdang
//
//  Created by 임대진 on 7/24/25.
//

import Foundation

struct Pageable: Codable {
    let offset: Int
    let sort: Sort
    let paged: Bool
    let pageNumber: Int
    let pageSize: Int
    let unpaged: Bool
}
