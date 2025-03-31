//
//  Notification.swift
//  imdang
//
//  Created by daye on 3/24/25.
//

import Foundation

struct NotificationResponse: Codable {
    let totalElements: Int
    let totalPages: Int
    let first: Bool
    let last: Bool
    let size: Int
    let content: [ImdangNotification]
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let pageable: Pageable
    let empty: Bool
    
    func toEntitiy() -> [ImdangNotification] {
        return content.map {
            ImdangNotification(notificationId: $0.notificationId, category: $0.category, message: $0.message, createdAt: $0.createdAt)
        }
    }
}

enum NotificationCategory: String {
    case requested = "REQUESTED"
    case accepted = "ACCEPTED"
    case rejected = "REJECTED"
    case requestedByCoupon = "REQUESTED_BY_COUPON"
}
