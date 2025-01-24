//
//  SearchingViewModel.swift
//  imdang
//
//  Created by 임대진 on 1/24/25.
//

import Foundation
import NetworkKit
import Alamofire
import RxSwift

final class SearchingViewModel {
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func loadMyInsight() -> Observable<[Insight]?> {
        let parameters: [String: Any] = [
            "pageNumber": 0,
            "pageSize": 10,
            "direction": "ASC",
            "properties": [ "created_at" ]
        ]
        
        let endpoint = Endpoint<InsightResponse>(
            baseURL: .imdangAPI,
            path: "/my-insights/created-by-me",
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
    
    func loadInsightDetail(id: String) -> Observable<InsightDetail?> {
        let parameters: [String: Any] = [
            "insightId": id
        ]
        
        let endpoint = Endpoint<InsightDetail>(
            baseURL: .imdangAPI,
            path: "/insights/detail",
            method: .get,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.request(with: endpoint)
            .map { data in
                return data
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(nil)
            }
    }
}
