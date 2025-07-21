//
//  DistrictsResponse.swift
//  imdang
//
//  Created by 임대진 on 2/5/25.
//

import Foundation

struct DistrictsResponse: Codable {
    let data: DistrictsData
    let error: ImdangError?
    
    func toAddresses() -> [DistrictAddress] {
        return data.content.map { $0 }
    }
}

struct DistrictsData: Codable {
    let totalElements: Int
    let totalPages: Int
    let size: Int
    let content: [DistrictAddress]
    let number: Int
    let sort: SortInfo
    let numberOfElements: Int
    let pageable: PageableInfo
    let first: Bool
    let last: Bool
    let empty: Bool
}

struct DistrictAddress: Codable {
    let siDo: String
    let siGunGu: String
    let eupMyeonDong: String?
    let code: String
}

struct SortInfo: Codable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

struct PageableInfo: Codable {
    let offset: Int
    let sort: SortInfo
    let paged: Bool
    let pageNumber: Int
    let pageSize: Int
    let unpaged: Bool
}
