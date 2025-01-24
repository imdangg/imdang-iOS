//
//  ServerJoinService.swift
//  imdang
//
//  Created by 임대진 on 1/15/25.
//

import Foundation
import NetworkKit
import RxSwift
import Alamofire

enum companyType {
    case google, kakao
}

class ServerJoinService {
    static let shared = ServerJoinService()
    
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func joinImdang(nickname: String, birthDate: String, gender: Gender) -> Observable<Bool> {
        let parameters: [String: String] = [
            "nickname": nickname,
            "birthDate": birthDate,
            "gender": gender.rawValue,
            "deviceToken": UserdefaultKey.deviceToken
        ]
        
        let endpoint = Endpoint<BasicResponse>(
            baseURL: .imdangAPI,
            path: "/auth/join",
            method: .put,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.requestOptional(with: endpoint)
            .map { _ in
                return true
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(false)
            }
    }
}

