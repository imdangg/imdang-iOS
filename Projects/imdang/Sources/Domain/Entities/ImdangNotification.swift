//
//  Notification.swift
//  imdang
//
//  Created by daye on 3/24/25.
//

import Foundation

struct ImdangNotification: Equatable, Codable {
    let notificationId: String
    let category: String
    let message: String
    let createdAt: Date
}
