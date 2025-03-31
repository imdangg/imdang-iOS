//
//  NotificationReactori.swift
//  imdang
//
//  Created by daye on 1/21/25.
//


import Foundation
import ReactorKit
import NetworkKit

struct MockNoti: Equatable {
    let username: String
    let type: NotiType
}

enum NotiType {
    case request_accept
    case request_reject
    case response
}

enum NotificationType: String, Equatable {
    case all = "전체"
    case request = "내가 요청한 내역"
    case response = "요청 받은 내역"
}

final class NotificationReactor: Reactor {
    private let networkManager = NetworkManager(session: .default)

    struct State {
        var notifications: [ImdangNotification] = [] // original
        var filterdNotifications: [ImdangNotification] = []
        var selectedNotificationType: NotificationType
    }

    enum Action {
        case tapNotificationTypeButton(NotificationType)
        case loadNotifications
    }

    enum Mutation {
        case changeSelectedNotificationType(NotificationType)
        case setNotifications([ImdangNotification])
    }

    var initialState: State

    init() {
        self.initialState = State(selectedNotificationType: .all)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadNotifications:
            let data = loadNotifications()
            return data
                .map { notifications in
                    print("!!!!!노티 없음")
                    return notifications ?? []
                }
                .map { notifications in
                    return .setNotifications(notifications)
                }
            
        case .tapNotificationTypeButton(let notificationType):
            return Observable.just(.changeSelectedNotificationType(notificationType))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
            // headerView 필터링
        case .changeSelectedNotificationType(let notificationType):
            
            if notificationType == .all {
                state.filterdNotifications = state.notifications
                
            } else if notificationType == .request {
                state.filterdNotifications = state.notifications.filter { $0.category == NotificationCategory.accepted.rawValue }
                
            } else if notificationType == .response {
                state.filterdNotifications = state.notifications.filter { $0.category == NotificationCategory.requested.rawValue || $0.category == NotificationCategory.requestedByCoupon.rawValue }
            }
            
            state.selectedNotificationType = notificationType
        case .setNotifications(let notifications):
            if state.selectedNotificationType == .all { //초기값을 위해
                state.filterdNotifications = notifications
            }
            state.notifications = notifications
        }
        return state
    }  
}
//case requested = "REQUESTED"
//case accepted = "ACCEPTED"
//case rejected = "REJECTED"
//case requestedByCoupon = "REQUESTED_BY_COUPON"

extension NotificationReactor {
    
    func loadNotifications() -> Observable<[ImdangNotification]?> {
        let parameters: [String: Any] = [
            "pageNumber": 0,
            "pageSize": 10,
            "direction": "DESC",
            "properties": ["createdAt"]
        ]
        
        let endpoint = Endpoint<NotificationResponse>(
            baseURL: .imdangAPI,
            path: "/notifications",
            method: .get,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.request(with: endpoint)
            .map { data in
                return data.toEntitiy()
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(nil)
            }
    }
}
