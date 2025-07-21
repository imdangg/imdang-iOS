//
//  HomeViewModel.swift
//  imdang
//
//  Created by 임대진 on 2/1/25.
//

import Foundation
import NetworkKit
import Alamofire
import RxSwift

final class HomeViewModel {
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func loadMyNickname() {
        let endpoint = Endpoint<MeDetail>(
            baseURL: .imdangAPI,
            path: "/members/me",
            method: .get,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)]
        )
        
        networkManager.request(with: endpoint)
            .subscribe { result in
                UserdefaultKey.memberNickname = result.nickname
            }
            .disposed(by: disposeBag)
    }
}
